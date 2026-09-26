from flask import Flask, render_template
import mariadb
import os

app = Flask(__name__)

@app.route('/')
def hello_world():
    conn = mariadb.connect(
        host=os.environ.get("DB_HOST"),
        user=os.environ.get("DB_USER",),
        password=os.environ.get("DB_PASSWORD",),
        database=os.environ.get("DB_NAME",),
        port=3306
    )
    cur = conn.cursor()
    cur.execute("SELECT VERSION()")
    version = cur.fetchone()
    conn.close()

    db_verssion = version[0]

    # Pass db-version  as db_version into index.html
    return render_template('index.html', db_version=db_verssion)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5003)

