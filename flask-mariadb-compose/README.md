# Flask + Non-Root MariaDB with Docker Compose

A Flask app connecting to a MariaDB container over a user-defined
Docker network. Both containers run as non-root, secrets via `.env`.

## 🎯 Objective

- Build a non-root MariaDB image
- Build a non-root Flask image
- Connect both containers over a custom Docker network
- Persist DB data in a Docker volume
- Use `.env` for secrets (never commit)
- Wait for MariaDB health before starting Flask

## 📁 Files

- `Dockerfile` — Flask app image (non-root)
- `Dockerfile.mariadb` — MariaDB image (non-root)
- `app.py` — Flask app querying MariaDB
- `requirements.txt` — `Flask`, `mariadb`
- `templates/index.html` — Shows DB version
- `docker-compose.yml` — Orchestrates both services
- `.env` — Local secrets (NOT committed)
- `.env.example` — Safe template
- `.dockerignore`, `.gitignore`

## 🚀 Run

```bash
docker compose up -d --build
