# CoderCo Containers Challenge

A multi-container Flask app with Redis for visit counting, Nginx as a reverse
proxy, and Docker Compose for orchestration. Built with a multi-stage Dockerfile
to keep the final image lean.

> 🔁 **Load-balanced:** Nginx fans out to N Flask replicas, each showing its own
> container IP on every page — refresh to see it change.

## Architecture

```
        ┌──────────────┐
        │   Browser    │
        └──────┬───────┘
               │ :5004
        ┌──────▼───────┐
        │    Nginx     │  (reverse proxy + health endpoint)
        └──────┬───────┘
               │ app:5004
        ┌──────▼───────┐
        │  Flask app   │  (gunicorn, 2 workers, non-root)
        └──────┬───────┘
               │ redis:6379
        ┌──────▼───────┐
        │    Redis     │  (AOF persistence → ./redis-data)
        └──────────────┘
```

## Stack

| Component | Version / Notes |
|-----------|-----------------|
| Flask | via gunicorn, 2 workers |
| Redis | 7-alpine, appendonly enabled |
| Nginx | alpine, reverse proxy |
| Python | 3.11-slim (multi-stage) |
| Docker Compose | v3 |

## Files

| File | Purpose |
|------|---------|
| `app.py` | Flask app — `/`, `/count`, `/about` |
| `Dockerfile` | Multi-stage build (builder → runner, non-root `ali`) |
| `docker-compose.yml` | `app` + `nginx` + `redis` services |
| `nginx.conf` | Reverse proxy + `/health` endpoint |
| `requirements.txt` | flask, redis, gunicorn |
| `templates/` | `base.html`, `index.html`, `redis-count.html`, `aboutme.html` |
| `redis-data/` | Redis AOF persistence volume |

## How it works

- **Flask app** — `/` welcome, `/count` increments a Redis key and renders the
  count, `/about` shows project info. Container hostname + IP are injected into
  every template via a `context_processor`.
- **Redis** — stores the visit counter, persists to `./redis-data` with AOF.
- **Nginx** — only public entry point on port `5004`; proxies to `app:5004` and
  exposes `/health`.
- **Compose** — Flask has no published ports; only Nginx is reachable from the
  host. This matches the intended "internal replicas, single public entry" design.

## Run

```bash
docker compose up -d --build
```

Open:
- http://localhost:5004 → welcome page
- http://localhost:5004/count → visit counter (increments on refresh)
- http://localhost:5004/about → about page
- http://localhost:5004/health → `OK`

Stop:
```bash
docker compose down       # keep Redis data
docker compose down -v    # also wipe named volumes
```

## Environment variables

Set in `docker-compose.yml` or a local `.env`:

| Var | Default | Used by |
|-----|---------|---------|
| `REDIS_HOST` | `redis` | Flask |
| `REDIS_PORT` | `6379` | Flask |

## Multi-stage build

`Dockerfile` uses two stages:

1. **builder** — installs deps into `/install` with `pip --prefix`
2. **runner** — copies `/install` → `/usr/local`, runs as non-root `ali` (UID 1001)

Result: no pip cache, no build tooling, minimal runtime surface.

## Scaling

```bash
docker compose up -d --scale app=3
docker compose restart nginx   # Nginx resolves upstream once at boot
```

Docker DNS round-robins `app` across replicas; Nginx's upstream forwards each
request to one of them.

### Verifying the load balancer

Every page shows the answering container's `hostname` and `IP`. Scaling the
Flask service makes these values rotate — confirming Nginx is load-balancing.

```bash
for i in $(seq 1 10); do
  curl -s http://localhost:5004/ | grep -oE '172\.[0-9]+\.[0-9]+\.[0-9]+'
done
```

Example output:

```
172.18.0.3
172.18.0.4
172.18.0.5
172.18.0.3
172.18.0.4
...
```

The IP changes with each request, while `/count` keeps climbing — proof that
all replicas share the same Redis instance.

## Tested

- Host: RHEL 9 (also works on macOS/Linux)
- Docker CE + Compose v2
- ✅ All routes reachable through Nginx
- ✅ `/count` increments and persists across container restarts
- ✅ Load balancing confirmed across 3 Flask replicas

### RHEL 9 notes

- SELinux enforcing → use `:Z` on bind mounts if you add them.
- To expose port `5004` externally:

  ```bash
  sudo firewall-cmd --add-port=5004/tcp --permanent
  sudo firewall-cmd --reload
  ```

## Troubleshooting

| Issue | Fix |
|-------|-----|
| 502 from Nginx | Flask not ready — check `docker compose logs app` |
| Counter resets | Redis AOF not persisting — confirm `./redis-data` is writable |
| Port 5004 in use | Change `"5004:80"` in `docker-compose.yml` |
| `REDIS_HOST` not set | Add it to `docker-compose.yml` or `.env` |
| Scaling has no effect | Restart Nginx after scaling so it re-resolves replicas |

## Notes

- Flask runs under **gunicorn**, not the dev server — production-safe.
- Only Nginx is exposed; Flask replicas stay internal.
- The challenge originally used port `5000`; this build uses `5004` to avoid
  conflicts with other local projects.
