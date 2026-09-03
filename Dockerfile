# Artemis v11 — v10's production build plus Prometheus instrumentation (/metrics).
# Multi-stage: build deps stay in the builder; the final image ships only a
# virtualenv + app, as a non-root user, pinned by digest.
FROM python:3.12-slim@sha256:2c941e860699f878900b0edc2403613c234d4b32eda3cc9fa7036991a2a63c4a AS builder

ENV PYTHONDONTWRITEBYTECODE=1
WORKDIR /artemis

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

FROM python:3.12-slim@sha256:2c941e860699f878900b0edc2403613c234d4b32eda3cc9fa7036991a2a63c4a

LABEL org.opencontainers.image.title="Artemis" \
      org.opencontainers.image.description="Artemis e-commerce demo application" \
      org.opencontainers.image.version="11.0.0" \
      org.opencontainers.image.source="https://github.com/farrukh90/artemis"

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PATH="/opt/venv/bin:$PATH"

WORKDIR /artemis

RUN useradd --create-home --shell /usr/sbin/nologin appuser
COPY --from=builder /opt/venv /opt/venv
COPY --chown=appuser:appuser . .
USER appuser

EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD python -c "import urllib.request,sys; sys.exit(0 if urllib.request.urlopen('http://127.0.0.1:5000/',timeout=2).status==200 else 1)"

# 1 worker keeps the in-process Prometheus counters consistent (multi-worker needs PROMETHEUS_MULTIPROC_DIR).
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "1", "--access-logfile", "-", "--error-logfile", "-", "artemis:app"]
