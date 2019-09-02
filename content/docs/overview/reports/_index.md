---
title: "Anchore Enterprise Reports"
linkTitle: "Reports"
weight: 4
---

### Overview

Added in Anchore Enterprise v2.0

Anchore Enterprise Reports is a new service introduced in v2.0. It aggregates data from Anchore Engine to provide insightful analytics and metrics for account-wide artifacts. The service employs GraphQL to expose a rich API for querying the aggregated data and metrics.  

> NOTE: This service captures a snapshot of artifacts in Anchore Engine at a given point in time. Therefore analytics and metrics computed by the service are not in real time, and may not reflect most up-to-date state in Anchore Engine  

### Installation

Anchore Enterprise Reports is included with Anchore Enterprise, and is installed by default when deploying a trial quickstart with [Docker Compose]({{< ref "/docs/installation/docker_compose" >}}) or a production deployment [Kubernetes]({{< ref "/docs/installation/helm" >}}).

### How it works

One of the main functions of Anchore Enterprise Reports is aggregating data from Anchore Engine. The service keeps a summary of all current and historical images and tags for every account known to Anchore Engine. It also maintains vulnerability reports and policy evaluations generated using the active bundle for all the images and tags respectively. 

> WARNING: Anchore Enterprise Reports shares persistence layer with Anchore Engine. Ensure sufficient storage is provisioned

#### Configuration

Anchore Enterprise Reports service loads it's configuration from the `reports` section of the config.yaml. Here is a snippet of just the section

```yaml
...
services:
  reports:
    enabled: true
    require_auth: true
    endpoint_hostname: "<hostname>"
    listen: '0.0.0.0'
    port: 8228
    # GraphiQL is a GUI for editing and testing GraphQL queries and mutations.
    # Set enable_graphiql to true and open http://<host>:<port>/v1/reports/graphql in a browser for reports API
    enable_graphiql: true
    # Set enable_data_ingress to true for periodically syncing data from anchore engine into the reports service
    enable_data_ingress: true
    cycle_timers:
      reports_data_load: 600 # images and tags synced every 10 minutes
      reports_data_refresh: 7200 # policy evaluations and vulnerabilities refreshed every 2 hours
      reports_metrics: 3600 # metrics generated every hour
    authorization_handler: external
    authorization_handler_config:
      endpoint: "<rbac-authorizer-endpoint>"
```

> NOTE: Any changes to the configuration requires a restart of the service for the updates to take effect

In an Anchore Enterprise RBAC enabled deployment, any non-admin account user must at least have _listImages_ permission to execute queries against Reports API

#### Data ingress

Reports service handles data ingress from Anchore Engine via the following asynchronous processes triggered periodically - 

- **Loader** Compares the working set of images and tags in Anchore Engine with its own records. Based on the difference, images and tags along with the vulnerability report and policy evaluations are loaded into the service. Artifacts deleted from Anchore Engine are marked inactive in the service. 

    This process is triggered periodically every 10 minutes (600 seconds). To modify the loader interval, update `cycle_timers` -> `reports_data_load` in the config.yaml snippet above. In a quickstart deployment, add `ANCHORE_ENTERPRISE_REPORTS_DATA_LOAD_INTERVAL_SEC=<interval-in-seconds>` to the environment variables section of the reports service in docker-compose.yaml.

- **Refresher** Refreshes the vulnerability report and policy evaluations of all the images and tags actively maintained by the service. 
    
    This process is triggered periodically every 2 hours (7200 seconds). To modify the refresher interval, update `cycle_timers` -> `reports_data_refresh` in the config.yaml snippet above. In a quickstart deployment, add `ANCHORE_ENTERPRISE_REPORTS_DATA_REFRESH_INTERVAL_SEC=<interval-in-seconds>` to the environment variables section of the reports service in docker-compose.yaml.

> WARNING: Reports service may miss updates to artifacts if they are added and deleted in between consecutive ingress processes

Data ingress is enabled by default. It can be turned off with `enable_data_ingress: false` in the config.yaml snippet above. In a quickstart deployment, add `ANCHORE_ENTERPRISE_REPORTS_ENABLE_DATA_INGRESS=false` to the environment variables section of the reports service in docker-compose.yaml. When the ingress is turned off, Reports service will no longer aggregate data from Anchore Engine, metric computations will also come to a halt. However, the service will continue to serve API requests/queries with the existing data.

#### Metrics

Reports service comes loaded with a few pre-defined/canned metric definitions. A metric definition consists of an identifier, readable name, description and the type of the metric. The type is loosely based on statsd metric types. Currently all the pre-defined metrics are of type 'counter' - a measure of the number of items that match certain criteria. A value for each of these metric definitions is computed using the data aggregated by the service. 

All metric values are computed periodically every hour (3600 seconds). To modify the interval, update `cycle_timers` -> `reports_metrics` in the config.yaml snippet above. In a quickstart deployment, add `ANCHORE_ENTERPRISE_REPORTS_METRICS_INTERVAL_SEC=<interval-in-seconds>` to the environment variables section of the reports service in docker-compose.yaml.

### See it in action

To see Reports service in the Enterprise UI go to [Dashboard]({{< ref "/docs/using/ui_usage/dashboard" >}}) or Reports view. Dashboard view utilizes metrics generated by the service and renders customizable widgets. Reports view employs graphQL queries and aggregates the results into multiple formats (csv, json etc).             

For using the API directly refer to [API Access]({{< ref "/docs/using/api_usage/reports" >}}) 


