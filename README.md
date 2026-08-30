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

 
