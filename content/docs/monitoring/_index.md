---
title: "Monitoring Anchore Enterprise"
linkTitle: "Monitoring"
weight: 5
---

Anchore Enterprise employs the same monitoring mechanisms as Anchore Engine, exposing prometheus metrics in the API of each service if the config.yaml used by that service has the metrics.enabled key set to true. See Anchore Engine > Monitoring > Prometheus for more details.

Each service exports its own metrics and is typically scraped by a Prometheus installation to gather the metrics. Anchore does not aggregate or distribute metrics between services. You should configure your Prometheus deployment or integration to check each Anchore service's api (using the same port it exports), for the /metrics route.

### Example with Quickstart docker-compose.yaml

An example prometheus.yaml to use to configure prometheus jobs that corresponds to the docker-compose.yaml bundled in the Enterprise container. To use this example, uncomment the anchore-prometheus service in the docker-compose.yaml:

```YAML
anchore-prometheus:
      image: docker.io/prom/prometheus:latest
      depends_on:
       - engine-api
      volumes:
       - ./anchore-prometheus.yml:/etc/prometheus/prometheus.yml:z
      logging:
       driver: "json-file"
       options:
        max-size: 100m
      ports:
       - "9090:9090"
```

Now, enable metrics for each engine or enterprise service:

`sed -i 's/ANCHORE_ENABLE_METRICS=false/ANCHORE_ENABLE_METRICS=true/g' docker-compose.yaml`

Next, create an anchore-prometheus.yml file in the same directory as the docker-compose.yaml with the following content:

```YAML
# This Prometheus configuration corresponds to the service names and ports in the docker-compose.yaml provided in the Enterprise docker image. Adjust names and ports accordingly for other environments.

global:
  scrape_interval: 15s
  scrape_timeout: 10s
  evaluation_interval: 15s
alerting:
  alertmanagers:
  - static_configs:
    - targets: []
    scheme: http
    timeout: 10s
scrape_configs:
- job_name: anchore-api
  scrape_interval: 15s
  scrape_timeout: 10s
  metrics_path: /metrics
  scheme: http
  static_configs:
  - targets:
    - engine-api:8228
  basic_auth:
    username: admin
    password: foobar

- job_name: anchore-catalog
  scrape_interval: 15s
  scrape_timeout: 10s
  metrics_path: /metrics
  scheme: http
  static_configs:
  - targets:
    - engine-catalog:8228
  basic_auth:
    username: admin
    password: foobar

- job_name: anchore-simplequeue
  scrape_interval: 15s
  scrape_timeout: 10s
  metrics_path: /metrics
  scheme: http
  static_configs:
  - targets:
    - engine-simpleq:8228
  basic_auth:
    username: admin
    password: foobar

- job_name: anchore-analyzer
  scrape_interval: 15s
  scrape_timeout: 10s
  metrics_path: /metrics
  scheme: http
  static_configs:
  - targets:
    - engine-analyzer:8228
  basic_auth:
    username: admin
    password: foobar

- job_name: enterprise-rbac-manager
  scrape_interval: 15s
  scrape_timeout: 10s
  metrics_path: /metrics
  scheme: http
  static_configs:
  - targets:
    - enterprise-rbac-manager:8228
  basic_auth:
    username: admin
    password: foobar

- job_name: anchore-policy-engine
  scrape_interval: 15s
  scrape_timeout: 10s
  metrics_path: /metrics
  scheme: http
  static_configs:
  - targets:
    - engine-policy-engine:8228
  basic_auth:
    username: admin
    password: foobar
- job_name: enterprise-feeds
  scrape_interval: 15s
  scrape_timeout: 10s
  metrics_path: /metrics
  scheme: http
  static_configs:
  - targets:
    - enterprise-feeds:8228
  basic_auth:
    username: admin
    password: foobar
```

Next: `docker-compose up -d`

Now you should be able to view metrics by opening a browser to: http://localhost:9090 to see the default prometheus console.

### Monitoring in Kubernetes and/or Helm Chart

Prometheus is very commonly used for monitoring kubernetes clusters and is supported by core kuberenetes services. There are many guides on using Prometheus to monitor a cluster and services deployed within, and also many other monitoring systems can consume Prometheus metrics.

The Anchore Helm Chart includes a quick way to enable the prometheus metrics on each service container:

Set: `helm install --name myanchore stable/anchore-engine --set anchoreGlobal.enableMetrics=true`

or, directly in your customized values.yaml

The specific strategy for monitoring services with prometheus is outside the scope of this document, but because Anchore exposes metrics on the /metrics route of all service ports, it should be compatible with most monitoring approaches (daemon sets, side-cars, etc).

### Metrics of Note

Anchore services export a range of metrics but here are some of specific interest for aiding in determining the health and load of an anchore deployment:

1. anchore_queue_length, specifically for queuename: "images_to_analyze"
    1. This is the number of images pending analysis, in the not_analyzed state
    2. As this number grows you can expect longer analysis times
    3. Adding more analyzers to a system can help drain the queue faster and keep wait times to a minimum.
    4. Example: anchore_queue_length{instance="engine-simpleq:8228",job="anchore-simplequeue",queuename="images_to_analyze"}
    5. This metric is exported from all simplequeue service instances, but is based on the database state so they should all present a consistent view of the length of the queue
2. anchore_monitor_runtime_seconds_count
    1. These metrics, one for each monitor, record the duration of the async processes as they execute on a duty cycle
    2. As the system grows, these will become longer to account for more tags to check for updates, repos to scan for new tags, and user notifications to process
3. anchore_tmpspace_available_bytes
    1. This metric tracks the available space in the "tmp_dir" location for each container. This is most important for the instances that are analyzers where this can indicate how much disk is being used for analysis and how much overhead there is for analyzing large images.
    2. This is expected to be consumed in cycles, with usage growing during analysis and then flushing upon completion. A consistent growth pattern here may indicate left over artifacts from analysis failures or a large layer_cache setting that is not yet full. The layer cache (see Layer Caching) is located in this space and thus will affect the metric.
4. process_resident_memory_bytes
    1. This is the memory actually consumed by the instance, where each instance is a service process of Anchore. Anchore is fairly memory intensive for large images and in deployments with lots of analyzed images due to lots of json parsing and marshalling, so monitoring this metric will help inform capacity requirements for different components based on your specific workloads. Lots of variables affect memory usage, so while we give recommendations in the Capacity Planning document, there is no substitute for profiling and monitoring your usage carefully.