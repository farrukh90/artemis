# Artemis v7 — describe the image with standard OCI metadata.
FROM python:3.12-slim

LABEL org.opencontainers.image.title="Artemis" \
      org.opencontainers.image.description="Artemis e-commerce demo application" \
      org.opencontainers.image.version="7.0.0" \
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

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "--access-logfile", "-", "--error-logfile", "-", "artemis:app"]
