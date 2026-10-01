from flask import Flask
import os
import pymysql
app = Flask(__name__)
@app.route('/')
def db_conn_check():
    conn = pymysql.connect(
        user=os.environ.get('DB_USER'),
        password=os.environ.get('DB_PASSWORD'),
        host=os.environ.get('DB_HOST'),
        port=int(os.environ.get('DB_PORT', 3306)),
        database=os.environ.get('DB_NAME')
    )

    cursor = conn.cursor()
    cursor.execute("SELECT version();")
    version = cursor.fetchone()   
    cursor.close()
    conn.close()
    return f"MariaDB version: {version[0]}" 
    
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5004)