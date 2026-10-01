import os
import redis
import socket
from flask import Flask, render_template

app = Flask(__name__)

r = redis.Redis(
    host=os.environ['REDIS_HOST'],
    port=int(os.environ['REDIS_PORT']),
    decode_responses=True,
)

# Automatically inject container metadata into ALL templates
@app.context_processor
def inject_container_info():
    container_id = socket.gethostname()
    try:
        container_ip = socket.gethostbyname(container_id)
    except Exception:
        container_ip = "127.0.0.1"
    return dict(container_id=container_id, container_ip=container_ip)

@app.route('/')
def welcome():
    return render_template('index.html')

@app.route('/count')
def count():
    visits = r.incr('visits')
    return render_template('redis-count.html', count=visits)

@app.route('/about')
def about():
    return render_template('aboutme.html')

if __name__ == '__main__':
    # Using host port 5004 to match your Docker setup
    app.run(host='0.0.0.0', port=5004)

