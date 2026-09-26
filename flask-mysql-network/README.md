# Flask + MySQL over a Docker Network (Non-Root)

A Flask app that connects to a MySQL container over a user-defined
Docker network, running as a non-root user inside the container.

## 🎯 Objective

- Test the Flask + MySQL connection locally first
- Create a custom Docker network for container-to-container DNS
- Run MySQL in a container on that network
- Run Flask in another container on the same network
- Connect Flask → MySQL using the container name as hostname
- Run the Flask container as a non-root user
- Keep credentials out of code using environment variables

## 📁 Files

- `Dockerfile` — Builds the Flask app image (non-root)
- `app.py` — Flask app that queries MySQL
- `requirements.txt` — Python dependencies
- `.env` — Local env vars (NOT committed)

## 🧪 Local Testing (Before Docker)

Before containerizing, I tested the Flask + MySQL connection locally
in an isolated Python virtual environment.

`mysqlclient` needs system build dependencies to compile. The exact
packages depend on your OS — below is what worked for me on
**RHEL 9 / Fedora**:

```bash
sudo dnf install -y python3-devel gcc pkgconfig MariaDB-devel
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python app.py
