import logging
import os
import sys
import time

from flask import (
    Flask, render_template, request, redirect, url_for, session, Response,
)
from prometheus_client import (
    Counter, Gauge, Histogram, generate_latest, CONTENT_TYPE_LATEST,
)

# ── Logging ─────────────────────────────────────────────────────────
# Log to STDOUT (never to a file): in a container the runtime — `docker logs`,
# Kubernetes, a log shipper — captures the process's stdout. LOG_LEVEL is env
# driven so you can turn up detail without a rebuild. PYTHONUNBUFFERED=1 in the
# Dockerfile makes these lines flush immediately instead of sitting in a buffer.
logging.basicConfig(
    level=os.environ.get("LOG_LEVEL", "INFO").upper(),
    format="%(asctime)s %(levelname)s [%(name)s] %(message)s",
    stream=sys.stdout,
)
log = logging.getLogger("artemis")

app = Flask(__name__)
app.secret_key = os.environ.get("ARTEMIS_SECRET_KEY", "artemis-demo-not-a-real-secret")

# ── Prometheus metrics ──────────────────────────────────────────────
# Request metrics (emitted for every request by the hooks below).
http_requests_total = Counter(
    "http_requests_total", "Total HTTP requests",
    ["method", "endpoint", "status"],
)
http_request_duration_seconds = Histogram(
    "http_request_duration_seconds", "HTTP request latency in seconds",
    ["method", "endpoint"],
)
# Business metrics (moved by the login / logout / checkout routes).
active_users = Gauge("active_users", "Currently logged-in users")
orders_total = Counter("orders_total", "Successfully placed orders")
login_failures_total = Counter("login_failures_total", "Failed login attempts")
payment_failures_total = Counter("payment_failures_total", "Declined payments")

# Demo rules — deterministic so the class can trigger each metric on purpose.
DEMO_PASSWORD = "moon"
DECLINE_CARD = "4000000000000002"

# Single-worker in-process count so active_users can never go negative
# (Flask sessions are client-side cookies; a logout after a restart would
# otherwise decrement a gauge that started at 0).
_active_users = 0


def _set_active(delta):
    global _active_users
    _active_users = max(0, _active_users + delta)
    active_users.set(_active_users)


@app.before_request
def _start_timer():
    request._start = time.perf_counter()


@app.after_request
def _record_request(response):
    endpoint = request.endpoint or "unknown"
    if endpoint != "metrics":
        elapsed = time.perf_counter() - getattr(request, "_start", time.perf_counter())
        http_request_duration_seconds.labels(request.method, endpoint).observe(elapsed)
        http_requests_total.labels(request.method, endpoint, response.status_code).inc()
        # One access line per request (skip /metrics so Prometheus scrapes don't
        # flood the log). Latency in ms makes slow requests obvious at a glance.
        log.info("%s %s -> %s in %.1fms",
                 request.method, request.path, response.status_code, elapsed * 1000)
    return response


@app.route("/")
def index():
    return render_template("index.html")


@app.route("/signup")
def signup():
    return render_template("signup.html")


@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        email = request.form.get("email", "guest")
        if request.form.get("password") == DEMO_PASSWORD:
            if "user" not in session:
                _set_active(+1)
            session["user"] = email
            log.info("login success: user=%s", email)
            return redirect(url_for("index"))
        login_failures_total.inc()
        log.warning("login failed: bad password for user=%s", email)
        return render_template("login.html", error="Invalid credentials."), 401
    return render_template("login.html")


@app.route("/logout")
def logout():
    user = session.pop("user", None)
    if user is not None:
        _set_active(-1)
        log.info("logout: user=%s", user)
    return redirect(url_for("index"))


@app.route("/checkout", methods=["GET", "POST"])
def checkout():
    if request.method == "POST":
        card = request.form.get("card", "").replace(" ", "")
        if card == DECLINE_CARD:
            payment_failures_total.inc()
            # Never log a full card number — last 4 digits only.
            log.warning("payment declined: card ending %s", card[-4:])
            return render_template("checkout.html", error="Payment declined."), 402
        orders_total.inc()
        log.info("order placed")
        return render_template("checkout.html", ordered=True)
    return render_template("checkout.html")


@app.route("/metrics")
def metrics():
    return Response(generate_latest(), mimetype=CONTENT_TYPE_LATEST)


log.info("Artemis 12.0.0 ready (log level %s)", logging.getLevelName(log.getEffectiveLevel()))


if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=False)
