# Artemis v5 — drop root. Run the app as an unprivileged user.
FROM python:3.12-slim

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

WORKDIR /artemis

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

RUN useradd --create-home --shell /usr/sbin/nologin appuser
COPY --chown=appuser:appuser . .
USER appuser

EXPOSE 5000

CMD ["python", "artemis.py"]
