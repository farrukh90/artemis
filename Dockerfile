# Artemis v8 — let the runtime know when the app is actually serving.
FROM python:3.12-slim

LABEL org.opencontainers.image.title="Artemis" \
      org.opencontainers.image.description="Artemis e-commerce demo application" \
      org.opencontainers.image.version="8.0.0" \
      org.opencontainers.image.source="https://github.com/farrukh90/artemis"

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

WORKDIR /artemis

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

RUN useradd --create-home --shell /usr/sbin/nologin appuser
COPY --chown=appuser:appuser . .
USER appuser

EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD python -c "import urllib.request,sys; sys.exit(0 if urllib.request.urlopen('http://127.0.0.1:5000/',timeout=2).status==200 else 1)"

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "artemis:app"]
