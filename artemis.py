import logging
import os
import sys
import time

from flask import Flask, render_template, request

# ── Logging ─────────────────────────────────────────────────────────
# Log to STDOUT so the container runtime — `docker logs`, Kubernetes, a log
# shipper — captures it (never log to a file in a container). LOG_LEVEL is env
# driven; Python's logging handler flushes every line immediately.
logging.basicConfig(
    level=os.environ.get('LOG_LEVEL', 'INFO').upper(),
    format='%(asctime)s %(levelname)s [%(name)s] %(message)s',
    stream=sys.stdout,
)
log = logging.getLogger('artemis')

app = Flask(__name__)


@app.before_request
def _start_timer():
    request._start = time.perf_counter()


@app.after_request
def _log_request(response):
    elapsed = time.perf_counter() - getattr(request, '_start', time.perf_counter())
    log.info('%s %s -> %s in %.1fms',
             request.method, request.path, response.status_code, elapsed * 1000)
    return response


@app.route('/')
def index():
    return render_template('index.html')

log.info('Artemis 2.0.0 ready (log level %s)',
         logging.getLevelName(log.getEffectiveLevel()))


if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=False)
