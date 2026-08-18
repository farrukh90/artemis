# Artemis v3 — install pinned deps from requirements.txt, cache the layer.
# Copy requirements FIRST so `pip install` is only re-run when deps change,
# not on every code edit.
FROM python:3.12-slim

WORKDIR /artemis

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["python", "artemis.py"]
