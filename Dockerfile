## Based image
FROM python:3

## Copy from root folder to artemis folder inside docker image
COPY . /artemis

## Expose 5000 port
EXPOSE 5000

## Install all packages
RUN pip install Flask

## Change dir
WORKDIR /artemis

## Run the application
CMD python artemis.py
