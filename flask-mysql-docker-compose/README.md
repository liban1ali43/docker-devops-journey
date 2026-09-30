# Flask + MySQL (Docker Compose)

Minimal Flask app connected to MySQL 8.0 via Docker Compose. Displays a users
table and exposes a JSON API.

## Stack
- Flask + mysql-connector-python
- MySQL 8.0
- Python 3.11-slim
- Docker Compose v3.9

## Layout

├── app.py # Flask app (2 routes)
├── docker-compose.yml # db + web services
├── Dockerfile # Flask image
├── init.sql # creates + seeds users table (runs once)
├── templates/index.html # Jinja2 users table
└── .env # local DB credentials (NOT committed)


## Run
```bash
docker compose up -d --build

docker compose down       # keep DB data
docker compose down -v    # wipe DB volume 
