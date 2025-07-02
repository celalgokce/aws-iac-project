from flask import Flask, jsonify
import datetime
import os

app = Flask(__name__)

@app.route("/")
def hello():
    return """
    <h1>Flask Sunucusu Çalışıyor!</h1>
    <p>Staj projesi başarıyla deploy edildi.</p>
    <ul>
        <li><a href="/health">Health Check</a></li>
        <li><a href="/info">Server Info</a></li>
        <li><a href="/metrics">Metrics</a></li>
    </ul>
    """

@app.route("/health")
def health():
    return jsonify({
        "status": "healthy",
        "timestamp": datetime.datetime.now().isoformat(),
        "service": "flask-app"
    })

@app.route("/info")
def info():
    return jsonify({
        "server": "Flask Development Server",
        "python_version": os.sys.version,
        "timestamp": datetime.datetime.now().isoformat(),
        "uptime": "Service is running"
    })

@app.route("/metrics")
def metrics():
    return """
    <h2>📊 Monitoring Endpoints</h2>
    <ul>
        <li><a href="http://{}:9100" target="_blank">Node Exporter (Port 9100)</a></li>
        <li><a href="http://{}:9090" target="_blank">Prometheus (Port 9090)</a></li>
        <li><a href="http://{}:3000" target="_blank">Grafana (Port 3000)</a></li>
    </ul>
    """.format(
        os.environ.get('SERVER_IP', 'localhost'),
        os.environ.get('SERVER_IP', 'localhost'),
        os.environ.get('SERVER_IP', 'localhost')
    )

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)