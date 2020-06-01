---
title: "Installing Anchore Enterprise on Google Kubernetes Engine (GKE)"
linkTitle: "Google Kubernetes Engine (GKE)"
weight: 3
---

This document will walkthrough the installation of Anchore Enterprise on a Google Kubernetes Engine (GKE) cluster and expose it on the public internet.
## Prerequisites

- A running GKE cluster with worker nodes launched. See [GKE Documentation](https://cloud.google.com/kubernetes-engine/docs/) for more information on this setup.
- [Helm](https://helm.sh/) client installed on local host.
- [Anchore CLI](https://docs.anchore.com/current/docs/installation/anchore_cli/) installed on local host.

Once you have a GKE cluster up and running with worker nodes launched, you can verity via the followiing command.

```
$ kubectl get nodes
NAME                                                STATUS   ROLES    AGE   VERSION
gke-standard-cluster-1-default-pool-c04de8f1-hpk4   Ready    <none>   78s   v1.13.7-gke.24
gke-standard-cluster-1-default-pool-c04de8f1-m03k   Ready    <none>   79s   v1.13.7-gke.24
gke-standard-cluster-1-default-pool-c04de8f1-mz3q   Ready    <none>   78s   v1.13.7-gke.24
```

## Anchore Helm Chart

Anchore maintains a [Helm chart](https://github.com/helm/charts/tree/master/stable/anchore-engine) to simplify the software installation process. An Enterprise installation of the chart will include the following:

- Anchore Enterprise software
- PostgreSQL (9.6.2)
- Redis (4)

To make the necessary configurations to the Helm chart, create a custom `anchore_values.yaml` file and reference it during installation. There are many options for configuration with Anchore, this document is intended to cover the minimum required changes to successfully install Anchore Enterprise on Google Kubernetes Engine.

**Note:** For this installation, a GKE ingress controller will be used. You can read more about Kubernetes Ingress with a GKE Ingress Controller [here](https://cloud.google.com/kubernetes-engine/docs/concepts/ingress)

### Configurations

Make the following changes below to your `anchore_values.yaml`

#### Ingress

```
ingress:
  enabled: true
  # Use the following paths for GCE/ALB ingress controller
  apiPath: /v1/*
  uiPath: /*
    # apiPath: /v1/
    # uiPath: /
    # Uncomment the following lines to bind on specific hostnames
    # apiHosts:
    #   - anchore-api.example.com
    # uiHosts:
    #   - anchore-ui.example.com
```

**Note:** Configuring ingress is optional. It is used throughout this guide to expose the Anchore deployment on the public internet.

#### Anchore Engine API Service

```
# Pod configuration for the anchore engine api service.
anchoreApi:
  replicaCount: 1

  # Set extra environment variables. These will be set on all api containers.
  extraEnv: []
    # - name: foo
    #   value: bar

  # kubernetes service configuration for anchore external API
  service:
    type: NodePort
    port: 8228
    annotations: {}
```

**Note:** Changed the service type to NodePort

#### Anchore Enterprise Global

```
anchoreEnterpriseGlobal:
  enabled: true
```

#### Anchore Enterprise UI

```
anchoreEnterpriseUi:
  # kubernetes service configuration for anchore UI
  service:
    type: NodePort
    port: 80
    annotations: {}
    sessionAffinity: ClientIP
```

**Note:** Changed service type to NodePort.

### Anchore Enterprise installation

#### Create secrets

Enterprise services require an Anchore Enterprise license, as well as credentials with permission to access the private DockerHub repository containing the enterprise software.

Create a kubernetes secret containing your license file:

`kubectl create secret generic anchore-enterprise-license --from-file=license.yaml=<PATH/TO/LICENSE.YAML>`

Create a kubernetes secret containing DockerHub credentials with access to the private Anchore Enterprise software:

`kubectl create secret docker-registry anchore-enterprise-pullcreds --docker-server=docker.io --docker-username=<DOCKERHUB_USER> --docker-password=<DOCKERHUB_PASSWORD> --docker-email=<EMAIL_ADDRESS>`

Install Anchore Enterprise:

`helm install --name anchore-enterprise stable/anchore-engine -f anchore_values.yaml`

It will take the system several minutes to bootstrap. You can checks on the status of the pods by running `kubectl get pods`:

```
$ kubectl get pods
NAME                                                              READY   STATUS    RESTARTS   AGE
anchore-enterprise-anchore-engine-analyzer-75679f559b-tnpkv       1/1     Running   0          15m
anchore-enterprise-anchore-engine-api-7ffd6b88f7-nkhtl            4/4     Running   0          15m
anchore-enterprise-anchore-engine-catalog-6db78fdf84-s25wl        1/1     Running   0          15m
anchore-enterprise-anchore-engine-enterprise-feeds-79d9c8bjqzr6   1/1     Running   0          15m
anchore-enterprise-anchore-engine-enterprise-ui-868d9bd5b5bddzd   1/1     Running   0          15m
anchore-enterprise-anchore-engine-policy-79cff7dcbd-ptjvh         1/1     Running   0          15m
anchore-enterprise-anchore-engine-simplequeue-77468954f5-48h5g    1/1     Running   0          15m
anchore-enterprise-anchore-feeds-db-8c8686fd7-k9pk5               1/1     Running   0          15m
anchore-enterprise-anchore-ui-redis-master-0                      1/1     Running   0          15m
anchore-enterprise-postgresql-57f65cb6d5-k7px5                    1/1     Running   0          15m
```

Run the following command for details on the deployed ingress resource:

```
$ kubectl describe ingress
Name:             anchore-enterprise-anchore-engine
Namespace:        default
Address:          34.96.64.148
Default backend:  default-http-backend:80 (10.8.2.6:8080)
Rules:
  Host  Path  Backends
  ----  ----  --------
  *
        /v1/*   anchore-enterprise-anchore-engine-api:8228 (<none>)
        /*      anchore-enterprise-anchore-engine-enterprise-ui:80 (<none>)
Annotations:
  kubernetes.io/ingress.class:            gce
  ingress.kubernetes.io/backends:         {"k8s-be-31175--55c0399dc5755377":"HEALTHY","k8s-be-31274--55c0399dc5755377":"HEALTHY","k8s-be-32037--55c0399dc5755377":"HEALTHY"}
  ingress.kubernetes.io/forwarding-rule:  k8s-fw-default-anchore-enterprise-anchore-engine--55c0399dc5750
  ingress.kubernetes.io/target-proxy:     k8s-tp-default-anchore-enterprise-anchore-engine--55c0399dc5750
  ingress.kubernetes.io/url-map:          k8s-um-default-anchore-enterprise-anchore-engine--55c0399dc5750
Events:
  Type    Reason  Age   From                     Message
  ----    ------  ----  ----                     -------
  Normal  ADD     15m   loadbalancer-controller  default/anchore-enterprise-anchore-engine
  Normal  CREATE  14m   loadbalancer-controller  ip: 34.96.64.148
```

The output above shows that an Load Balancer has been created. Navigate to the specified URL in a browser:

![login](anchore-login.png)

#### Anchore System

Check the status of the system with the Anchore CLI to verify all of the Anchore services are up:

**Note:** Read more on [Configuring the Anchore CLI](https://docs.anchore.com/current/docs/installation/anchore_cli/cli_config/)

```
$ anchore-cli --url http://34.96.64.148/v1/ --u admin --p foobar system status
Service catalog (anchore-enterprise-anchore-engine-catalog-6db78fdf84-s25wl, http://anchore-enterprise-anchore-engine-catalog:8082): up
Service apiext (anchore-enterprise-anchore-engine-api-7ffd6b88f7-nkhtl, http://anchore-enterprise-anchore-engine-api:8228): up
Service reports (anchore-enterprise-anchore-engine-api-7ffd6b88f7-nkhtl, http://anchore-enterprise-anchore-engine-enterprise-reports:8558): up
Service rbac_authorizer (anchore-enterprise-anchore-engine-api-7ffd6b88f7-nkhtl, http://localhost:8089): up
Service rbac_manager (anchore-enterprise-anchore-engine-api-7ffd6b88f7-nkhtl, http://anchore-enterprise-anchore-engine-api:8229): up
Service analyzer (anchore-enterprise-anchore-engine-analyzer-75679f559b-tnpkv, http://anchore-enterprise-anchore-engine-analyzer:8084): up
Service simplequeue (anchore-enterprise-anchore-engine-simplequeue-77468954f5-48h5g, http://anchore-enterprise-anchore-engine-simplequeue:8083): up
Service policy_engine (anchore-enterprise-anchore-engine-policy-79cff7dcbd-ptjvh, http://anchore-enterprise-anchore-engine-policy:8087): up

Engine DB Version: 0.0.13
Engine Code Version: 0.7.1
```

#### Anchore Feeds

It can take some time to fetch all of the vulnerability feeds from the upstream data sources. Check on the status of feeds with the Anchore CLI:

```
$ anchore-cli --url http://34.96.64.148/v1/ --u admin --p foobar system feeds list
```

**Note:** It is not uncommon for the above command to return a: `[]` as the initial feed sync occurs.

Once the vulnerability feed sync is complete, Anchore can begin to return vulnerability results on analyzed images. Please continue to the [Usage]({{< ref "/docs/using" >}}) section of our documentation for more information.
