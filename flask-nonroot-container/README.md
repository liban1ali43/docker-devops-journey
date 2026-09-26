# Flask App in Docker (Non-Root User)

A simple Flask application containerized with Docker and run as a
non-root user for better security.

## 🎯 Objective

- Test the Flask app locally first (without Docker)
- Containerize it with a custom Dockerfile
- Run the container as a non-root user (`appuser`)
- Expose the app on port `5003`

## 📁 Files

- `Dockerfile` — Builds the Flask app image
- `app.py` — Flask application
- `requirements.txt` — Python dependencies

## 🧪 Local Testing (Before Docker)

Before containerizing, I tested `app.py` locally in an isolated
Python virtual environment.

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python app.py
