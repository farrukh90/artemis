# Artemis v1 — a clean, minimal image.
# Pin a small, specific base (not the huge, unpinned `python:3`).
FROM python:3.12-slim

# Work inside a dedicated directory.
WORKDIR /artemis

# Copy the app and install its one dependency.
COPY . .
RUN pip install Flask

# Flask listens on 5000.
EXPOSE 5000

# Exec-form CMD so signals reach the app.
CMD ["python", "artemis.py"]
