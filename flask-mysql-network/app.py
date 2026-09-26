import os
import MySQLdb
from flask import Flask

app = Flask(__name__)


@app.route("/")
def hello_world():
    db = MySQLdb.connect(
        host=os.environ.get("DB_HOST"),
        user=os.environ.get("DB_USER"),
        passwd=os.environ.get("DB_PASSWORD"),
        db=os.environ.get("DB_NAME"),
    )
    cur = db.cursor()
    cur.execute("SELECT VERSION()")
    version = cur.fetchone()
    db.close()
    return f"Hello, world! MySQL version: {version[0]}"


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5002)

