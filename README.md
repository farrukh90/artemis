# Artemis E-commerse Web-Application

# This repository contains all the requirements of artemis application. And the application is versioned in branches
```
https://github.com/farrukh90/artemis/tree/master
```
## Following this commands 
 ## 1. Clone repo
 ```
 git clone https://github.com/farrukh90/artemis.git
 ```

 ## 2. Build image following commands
 ```
 * docker image build -t "artemis repo from GCP"/artemis:10.0.0 .

 * docker push "artemis repo from GCP"/artemis:10.0.0 

 * git chekout 10.0.0
 ```
 ## Output should be like this
 <img width="689" alt="Screenshot 2023-04-01 at 3 17 22 PM" src="https://user-images.githubusercontent.com/80778542/229955711-2ea1ec12-ebcf-4f58-bb1e-edbc0774ea28.png">

---

## Observability (v11.0.0) — Prometheus metrics

Version `11.0.0` is v10's production build plus Prometheus instrumentation. The app
exposes `/metrics` in Prometheus text format; point Prometheus at it and build Grafana
panels.

### Run it
```
docker build -t artemis:11.0.0 .
docker run -p 8000:5000 artemis:11.0.0     # NOT 5000 on macOS — AirPlay uses it
curl http://localhost:8000/metrics
```

### Metrics exposed
| Metric | Type | How to make it move |
| --- | --- | --- |
| `http_requests_total{method,endpoint,status}` | counter | any request to any route |
| `http_request_duration_seconds{method,endpoint}` | histogram | any request (latency) |
| `active_users` | gauge | log in (`+1`) / log out (`-1`) |
| `orders_total` | counter | successful checkout |
| `login_failures_total` | counter | wrong password at `/login` |
| `payment_failures_total` | counter | declined card at `/checkout` |

### Triggering the business metrics (deterministic — for class demos)
```
# a successful login  -> active_users +1
curl -c jar -d 'email=a@b.co&password=moon' http://localhost:8000/login
# a failed login      -> login_failures_total +1
curl -d 'email=a@b.co&password=wrong'       http://localhost:8000/login
# a placed order      -> orders_total +1
curl -d 'card=4111111111111111'             http://localhost:8000/checkout
# a declined payment  -> payment_failures_total +1
curl -d 'card=4000000000000002'             http://localhost:8000/checkout
```

Password `moon` logs in; card `4000000000000002` is the "declined" test card. Everything
else succeeds.

> The image runs gunicorn with **1 worker** on purpose: `prometheus_client` keeps counters
> per process, so multiple workers would each report their own numbers. Scaling out needs
> `PROMETHEUS_MULTIPROC_DIR` — a good follow-up exercise for the class.

---

## Logging (v12.0.0)

Version `12.0.0` is v11 plus application logging. The app logs to **stdout** (the
container runtime — `docker logs`, Kubernetes, a log shipper — captures it), so there
are no log files to manage.

### Run it and watch the logs
```
docker build -t artemis:12.0.0 .
docker run -p 8000:5000 artemis:12.0.0     # NOT 5000 on macOS — AirPlay uses it
# in another terminal:
docker logs -f <container>                 # or just watch the `docker run` output
```

### What gets logged
| Event | Level | Example |
| --- | --- | --- |
| Every request (except `/metrics`) | INFO | `GET /login -> 200 in 3.4ms` |
| Successful login | INFO | `login success: user=a@b.co` |
| Failed login | WARNING | `login failed: bad password for user=a@b.co` |
| Logout | INFO | `logout: user=a@b.co` |
| Order placed | INFO | `order placed` |
| Declined payment | WARNING | `payment declined: card ending 0002` |

Gunicorn's own access and error logs also go to stdout (`--access-logfile -`,
`--error-logfile -`), so you see both the server and the app in one stream.

### Turn the detail up or down
```
docker run -p 8000:5000 -e LOG_LEVEL=DEBUG artemis:12.0.0
```
`LOG_LEVEL` defaults to `INFO`. Card numbers are never logged in full — only the last
four digits — a deliberate example of not writing secrets to logs.

