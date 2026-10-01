# Flask + MariaDB (Multi-Stage Docker)

A Flask app connected to MariaDB, built with a **multi-stage Dockerfile** to
keep the final image small. Runs with Docker Compose.

## Why multi-stage?

The build stage installs Python dependencies into `/install`. The runtime
stage copies **only** that folder into `/usr/local` — no pip cache, no build
junk. Result: a lean image with just Flask + pymysql and the app code.

## Stack

| Tool | Version |
|------|---------|
| Flask | latest |
| pymysql | latest |
| Python | 3.8-slim |
| MariaDB | 11 |
| Docker Compose | v3 |

## Files

| File | Purpose |
|------|---------|
| `app.py` | Flask app — returns MariaDB version |
| `Dockerfile` | Multi-stage build for the Flask image |
| `Dockerfile.mariadb` | Custom MariaDB image (non-root, UID 999) |
| `docker-compose.yml` | `mariadb` + `flaskapp` services |
| `requirements.txt` | Flask, pymysql |
| `.env` | DB credentials — not committed |

## How it works

- **`Dockerfile`** — two stages:
  1. `build` — installs deps with `pip --prefix=/install`
  2. runtime — copies `/install` → `/usr/local`, runs as non-root `amira` (UID 1001)
- **`Dockerfile.mariadb`** — runs MariaDB as UID 999 (non-root), owns `/var/lib/mysql`
- **`docker-compose.yml`** — starts MariaDB with a healthcheck, waits for it,
  then starts Flask on port `5004`

## Run

```bash
docker compose up -d --build
```

Open: http://localhost:5004

Expected output:
```
MariaDB version: 11.x.x-MariaDB
```

Stop:
```bash
docker compose down       # keep DB data
docker compose down -v    # wipe DB volume
```

## Env vars

Set in `.env` (not committed). See `.env.example` for keys.

| Var | Used by |
|-----|---------|
| `DB_ROOT_PASSWORD` | MariaDB root |
| `DB_NAME` | Database name |
| `DB_USER` | App + MariaDB user |
| `DB_PASSWORD` | App + MariaDB password |

## Non-root setup

| Container | User | UID |
|-----------|------|-----|
| Flask | `amira` | 1001 |
| MariaDB | `mysql` | 999 |

Both run as non-root. `/home/amira/app` is owned by `amira`, so Python can
write `__pycache__` at runtime.

## Notes

- `init.sql` is **not** used — no seed data.
- Flask runs with the dev server (`app.run`), not for production.
- Tested on RHEL 9 with Docker CE. SELinux enforcing → use `:Z` on bind mounts.

## Troubleshooting

| Issue | Fix |
|-------|-----|
| DB not ready | Compose waits via `healthcheck` — check `docker compose logs mariadb` |
| Access denied | Check `.env` matches compose env vars |
| Port 5004 in use | Remap in `docker-compose.yml` |
| Permission error on `/var/lib/mysql` | Confirm MariaDB runs as UID 999 |
