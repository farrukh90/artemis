# Artemis v4 — sane Python runtime settings.
# PYTHONUNBUFFERED: logs stream immediately. PYTHONDONTWRITEBYTECODE: no .pyc clutter.
FROM python:3.12-slim

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

WORKDIR /artemis

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["python", "artemis.py"]
