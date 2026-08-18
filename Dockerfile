# Artemis v2 — keep junk out of the image and skip the pip cache.
# See .dockerignore: .git, images and caches never enter the build context.
FROM python:3.12-slim

WORKDIR /artemis

COPY . .
RUN pip install --no-cache-dir Flask

EXPOSE 5000

CMD ["python", "artemis.py"]
