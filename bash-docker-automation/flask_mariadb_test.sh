#!/usr/bin/bash
set -e

# ============================================
# Configuration
# ============================================
NETWORK_NAME="flask-mariadb-net"
MARIADB_CONTAINER="mariadb-server"
FLASK_CONTAINER="flask-app"
DB_ROOT_PASS="secretroot"
DB_NAME="mydb"
DB_USER="ali"
DB_PASS="appsecret"
FLASK_PORT="5003"

echo "=== 1. Creating custom network: $NETWORK_NAME ==="
docker network rm "$NETWORK_NAME" 2>/dev/null || true
docker network create "$NETWORK_NAME"

echo "=== 2. Starting MariaDB container ==="
docker run -d \
  --name "$MARIADB_CONTAINER" \
  --network "$NETWORK_NAME" \
  --network-alias db \
  -e MYSQL_ROOT_PASSWORD="$DB_ROOT_PASS" \
  -e MYSQL_DATABASE="$DB_NAME" \
  -e MYSQL_USER="$DB_USER" \
  -e MYSQL_PASSWORD="$DB_PASS" \
  mariadb:latest

echo "MariaDB container started."

echo "=== 3. Waiting for MariaDB readiness ==="
until docker exec "$MARIADB_CONTAINER" mariadb-admin ping -h localhost --silent 2>/dev/null; do
  sleep 2
done
echo "MariaDB is ready."

echo "=== 4. Building Flask app image ==="
BUILD_DIR=$(mktemp -d)
cd "$BUILD_DIR"

# --- Dockerfile ---
cat > Dockerfile << 'EOF'
FROM python:3.11-slim

WORKDIR /app

RUN pip install --no-cache-dir flask pymysql

COPY app.py .

EXPOSE 5003

CMD ["python", "app.py"]
EOF

# --- Flask application ---
cat > app.py << 'EOF'
import os
import time
import pymysql
from flask import Flask, jsonify

app = Flask(__name__)

DB_HOST = os.getenv("DB_HOST", "db")
DB_PORT = int(os.getenv("DB_PORT", 3306))
DB_USER = os.getenv("DB_USER", "ali")
DB_PASS = os.getenv("DB_PASS", "appsecret")
DB_NAME = os.getenv("DB_NAME", "mydb")

def get_db_connection(retries=10, delay=2):
    for attempt in range(retries):
        try:
            conn = pymysql.connect(
                host=DB_HOST,
                port=DB_PORT,
                user=DB_USER,
                password=DB_PASS,
                database=DB_NAME,
                connect_timeout=5
            )
            return conn
        except pymysql.Error as e:
            print(f"Connection attempt {attempt + 1} failed: {e}")
            time.sleep(delay)
    raise RuntimeError("Could not connect to MariaDB after multiple attempts")

@app.route("/")
def index():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT VERSION()")
    version = cur.fetchone()
    cur.close()
    conn.close()
    return f'Hello, world! MySQL version: {version[0]}'

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5003)
EOF

docker build -t flask-mariadb-app .

cd - > /dev/null
rm -rf "$BUILD_DIR"

echo "=== 5. Starting Flask container ==="
docker rm -f "$FLASK_CONTAINER" 2>/dev/null || true
docker run -d \
  --name "$FLASK_CONTAINER" \
  --network "$NETWORK_NAME" \
  -p "${FLASK_PORT}:5003" \
  -e DB_HOST="db" \
  -e DB_PORT="3306" \
  -e DB_USER="$DB_USER" \
  -e DB_PASS="$DB_PASS" \
  -e DB_NAME="$DB_NAME" \
  flask-mariadb-app

echo "Flask container started. Waiting for it to be ready..."
sleep 5

echo "=== 6. Testing Flask → MariaDB connection ==="
echo ""

RESPONSE=$(curl -s http://localhost:${FLASK_PORT}/)

if [ -z "$RESPONSE" ]; then
  echo "ERROR: No response from Flask app."
  echo "--- Flask logs ---"
  docker logs "$FLASK_CONTAINER"
  exit 1
fi

echo "Response from Flask app:"
echo "$RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$RESPONSE"

# ============================================
# 7. Cleanup
# ============================================
echo ""
echo "=== 7. Cleaning up ==="
docker stop "$FLASK_CONTAINER" "$MARIADB_CONTAINER" > /dev/null
docker rm "$FLASK_CONTAINER" "$MARIADB_CONTAINER" > /dev/null
docker network rm "$NETWORK_NAME" > /dev/null
docker rmi flask-mariadb-app > /dev/null 2>&1 || true

echo "Done."

