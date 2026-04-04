from flask import Flask, jsonify
import os, platform, datetime, time

app = Flask(__name__)
START_TIME = time.time()

@app.route('/')
def home():
    return jsonify({
        "message": "Hello from DevOps Project 4 on Kubernetes! - Version 1.1.0!",
        "version": os.environ.get("APP_VERSION", "1.0.0"),
        "environment": os.environ.get("ENVIRONMENT", "dev"),
        "pod_name": platform.node(),
        "kubernetes": True,
        "timestamp": datetime.datetime.utcnow().isoformat()
    })

@app.route('/health/live')
def liveness():
    """Kubernetes liveness probe endpoint"""
    return jsonify({"status": "broken"}), 500

@app.route('/health/ready')
def readiness():
    """Kubernetes readiness probe endpoint"""
    uptime = time.time() - START_TIME
    if uptime < 5:
        return jsonify({"status": "not ready", "uptime": uptime}), 503
    return jsonify({"status": "ready", "uptime": round(uptime, 2)}), 200

@app.route('/metrics-demo')
def metrics():
    return jsonify({
        "requests_total": 42,
        "uptime_seconds": round(time.time() - START_TIME, 2)
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=False)
