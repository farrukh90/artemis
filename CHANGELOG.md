# Changelog

All notable changes to **Artemis** are recorded here. This repository teaches how a
container image *and* the app it ships evolve from a naive first cut to a
production-grade build. Each version lives on its own git branch (`1.0.0` … `10.0.0`);
this file, on branch `3.0.0`, covers `1.0.0` through `3.0.0`.

The format follows [Keep a Changelog](https://keepachangelog.com/). Every entry lists
what changed in the **Docker** image and in the **Storefront** for that version.


## [3.0.0] - 2026-08-17

**Docker:** Install pinned dependencies from `requirements.txt`; copy requirements **before** the app so the `pip install` layer is cached and only rebuilt when deps change.

**Storefront:** Add a sticky nav with the moon brand mark, a hero with a gold call-to-action, and a `/signup` page.


## [2.0.0] - 2026-08-17

**Docker:** Add a `.dockerignore` so `.git`, images, and caches never enter the build context; install with `pip install --no-cache-dir` to keep the layer lean.

**Storefront:** Introduce a stylesheet and web fonts (Fraunces + Archivo); center the hero.


## [1.0.0] - 2026-08-17

**Docker:** Pin a small, specific base image `python:3.12-slim` instead of the huge, unpinned `python:3`. Set `WORKDIR` first; use exec-form `CMD` so signals reach the app.

**Storefront:** Minimal storefront: a single `Artemis` heading and tagline, no styling — the deliberate starting point of the progression.
