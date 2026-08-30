# Changelog

All notable changes to **Artemis** are recorded here. This repository teaches how a
container image *and* the app it ships evolve from a naive first cut to a
production-grade build. Each version lives on its own git branch (`1.0.0` … `11.0.0`);
this file, on branch `11.0.0`, covers `1.0.0` through `11.0.0`.

The format follows [Keep a Changelog](https://keepachangelog.com/). Every entry lists
what changed in the **Docker** image and in the **Storefront** for that version.


## [11.0.0] - 2026-08-30

**Observability:** Instrument the Flask app with `prometheus_client` and expose `/metrics`. Six metrics: `http_requests_total` and `http_request_duration_seconds` (every request, via `before_request`/`after_request` hooks), plus `active_users`, `orders_total`, `login_failures_total`, and `payment_failures_total` driven by real login/logout/checkout routes. Password `moon` logs in; card `4000000000000002` is declined.

**Docker:** Inherits v10's multi-stage, non-root, digest-pinned build; runs gunicorn with a single worker so the in-process counters stay consistent.


## [10.0.0] - 2026-08-17

**Docker:** Multi-stage build: dependencies compile in a builder stage; the final image ships only a virtualenv plus the app, running as a non-root user, pinned by digest.

**Storefront:** Complete storefront: an eight-product grid rendered from data plus a newsletter sign-up.


## [9.0.0] - 2026-08-17

**Docker:** Pin the base image by digest (`python:3.12-slim@sha256:...`). Tags move; digests don't — the build is now reproducible.

**Storefront:** Add New / Sale badges and a working cart counter (JavaScript).

**Security:** Digest pinning guarantees the exact base image bytes, preventing a moved tag from silently changing what ships.


## [8.0.0] - 2026-08-17

**Docker:** Add a `HEALTHCHECK` so the runtime knows when the app is actually serving, not just started.

**Storefront:** Add load animations, category tiles, and a responsive layout.


## [7.0.0] - 2026-08-17

**Docker:** Describe the image with standard OCI `LABEL` metadata (title, description, source, licence).

**Storefront:** Add a frosted-glass nav, a moon-orb hero, and a footer.


## [6.0.0] - 2026-08-17

**Docker:** Serve with the gunicorn WSGI server instead of Flask's built-in debug server.

**Storefront:** Ship the full brand theme (color variables, gold buttons) and add a `/login` page.

**Security:** Disabling Flask's debug server removes the Werkzeug interactive debugger, which allows remote code execution if the app is ever exposed.


## [5.0.0] - 2026-08-17

**Docker:** Drop root: create an unprivileged `appuser` and run the container as that user.

**Storefront:** Give product cards image placeholders and a hover-lift interaction.


## [4.0.0] - 2026-08-17

**Docker:** Set Python runtime hygiene env vars: `PYTHONUNBUFFERED=1` (logs stream immediately) and `PYTHONDONTWRITEBYTECODE=1` (no `.pyc` clutter).

**Storefront:** Add the first product grid.


## [3.0.0] - 2026-08-17

**Docker:** Install pinned dependencies from `requirements.txt`; copy requirements **before** the app so the `pip install` layer is cached and only rebuilt when deps change.

**Storefront:** Add a sticky nav with the moon brand mark, a hero with a gold call-to-action, and a `/signup` page.


## [2.0.0] - 2026-08-17

**Docker:** Add a `.dockerignore` so `.git`, images, and caches never enter the build context; install with `pip install --no-cache-dir` to keep the layer lean.

**Storefront:** Introduce a stylesheet and web fonts (Fraunces + Archivo); center the hero.


## [1.0.0] - 2026-08-17

**Docker:** Pin a small, specific base image `python:3.12-slim` instead of the huge, unpinned `python:3`. Set `WORKDIR` first; use exec-form `CMD` so signals reach the app.

**Storefront:** Minimal storefront: a single `Artemis` heading and tagline, no styling — the deliberate starting point of the progression.
