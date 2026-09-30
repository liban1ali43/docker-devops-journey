import os
import mysql.connector
from flask import Flask, render_template, jsonify

app = Flask(__name__)

# Read DB config from environment variables (set in docker-compose)
DB_CONFIG = {
    "host": os.getenv("DB_HOST"),
    "user": os.getenv("DB_USER"),
    "password": os.getenv("DB_PASSWORD"),
    "database": os.getenv("DB_NAME"),
    "port": int(os.getenv("DB_PORT")),
}


def get_connection():
    return mysql.connector.connect(**DB_CONFIG)


@app.route("/")
def index():
    try:
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT id, name, email FROM users")
        users = cursor.fetchall()
        cursor.close()
        conn.close()
        return render_template("index.html", users=users)
    except Exception as e:
        return f"<h2>DB Error:</h2><pre>{e}</pre>", 500


@app.route("/api/users")
def api_users():
    """JSON endpoint - useful for testing."""
    try:
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT id, name, email FROM users")
        users = cursor.fetchall()
        cursor.close()
        conn.close()
        return jsonify(users)
    except Exception as e:
        return jsonify({"error": str(e)}), 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5003, debug=True)
