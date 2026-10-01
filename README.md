# Docker Learning & Hands-On Projects

This repository documents my hands-on Docker learning journey —
containerization, networking, storage, multi-container applications,
image optimization, load balancing, and container troubleshooting.

Each project was built and tested locally while developing my DevOps
and Platform Engineering skills.

## Repository Structure

Each folder is a self-contained project with its own README:

| Project | Focus |
|---------|-------|
| [flask-mysql-docker-compose](./flask-mysql-docker-compose) | Flask + MySQL via Compose, env vars, init.sql |
| [flask-mariadb-compose](./flask-mariadb-compose) | Flask + MariaDB via Compose |
| [flask-mysql-network](./flask-mysql-network) | Custom networks, container-to-container DNS |
| [flask-nonroot-container](./flask-nonroot-container) | Running Flask as a non-root user |
| [flask-multistage](./flask-multistage) | Multi-stage build to shrink the image |
| [bash-docker-automation](./bash-docker-automation) | Self-contained bash script — build, run, test, clean up |
| [coderco-containers-challenge](./coderco-containers-challenge) | Nginx + Flask replicas + Redis, load balancing, scaling |

## Docker Topics Covered

### Images & Containers

- ✅ Pulling images from public registries
- ✅ Running, inspecting, and managing containers
- ✅ Building custom images
- ✅ Tagging images

### Dockerfiles

- ✅ Writing Dockerfiles
- ✅ Common Dockerfile instructions
- ✅ Building Python (Flask) application images
- ✅ Multi-stage builds
- ✅ Runtime image optimization (`--prefix=/install` → `/usr/local`)
- ✅ Non-root users and UID/GID ownership

### Networking

- ✅ Docker networks (bridge)
- ✅ Container-to-container communication
- ✅ Service discovery by container name
- ✅ Custom networks with Docker Compose
- ✅ Reverse proxy with Nginx
- ✅ Load balancing across replicas

### Docker Compose

- ✅ Multi-container applications
- ✅ Flask + MySQL (volume + network)
- ✅ Flask + MariaDB
- ✅ Flask + Redis
- ✅ Environment variables via `.env`
- ✅ Service dependencies and healthchecks
- ✅ Scaling replicas (`--scale app=3`)

### Storage

- ✅ Docker volumes
- ✅ Bind mounts
- ✅ Persistent container data
- ✅ Redis AOF persistence

### Security & Runtime

- ✅ Environment variables
- ✅ Non-root containers
- ✅ Separating build and runtime environments
- ✅ Minimizing runtime dependencies
- ✅ Gunicorn as the production WSGI server

### Automation

- ✅ Bash scripting for Docker workflows
- ✅ Build → run → test → cleanup in a single script
- ✅ Health-check wait loops

### Troubleshooting

- ✅ `docker logs`, `docker exec`, `docker inspect`, `docker stats`
- ✅ Container networking issues
- ✅ Application-to-database connectivity
- ✅ Image and container debugging

## Skills Demonstrated

Dockerfile authoring · Docker Compose · custom networks · volumes and
bind mounts · non-root containers · multi-stage builds · Nginx reverse
proxy · load balancing · Redis persistence · gunicorn · bash automation

## Tested On

- **Host:** RHEL 9 (Red Hat Enterprise Linux 9)
- **Runtime:** Docker CE + Docker Compose v2
- **Notes:** SELinux enforcing, firewalld active

## Notes

- Secrets live in `.env` files (git-ignored). See `.env.example` where present.
- Each project folder has its own README with setup and troubleshooting.
