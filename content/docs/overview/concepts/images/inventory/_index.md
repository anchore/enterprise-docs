---
title: "Kubernetes Runtime Inventory"
linkTitle: "Kubernetes Runtime  Inventory"
weight: 1
---

## Configuration
Anchore uses a go binary called [kai](https://github.com/anchore/kai) that leverages the [Kubernetes Go SDK](https://github.com/kubernetes/client-go) to reach out and list pods in a configurable set of namespaces to determine which images are running.

This binary is installed into the Enterprise Docker Image and can be configured using the REST API, but depends on Anchore knowing your cluster configuration and corresponding credentials. On the other hand, `kai` can also be run via it's helm chart, embedded within your Kubernetes cluster as an agent. In this run-mode, it will require access to the Anchore API.  

## Agent Mode
The most common way to track inventory is to install [`kai`](https://github.com/anchore/kai). as an agent in your cluster. To do this you will need to configure credentials
and information about your deployment in the values file. It is recommended to first [configure a specific robot user](/current/docs/using/cli_usage/user_management/) for the account you'll want to track your inventory in. 

As an agent kai is installed using helm and the helm chart is hosted as part of the https://charts.anchore.io repo. It is based on the [anchore/kai](https://hub.docker.com/r/anchore/kai) docker image. 

To install the helm chart, follow these steps:

1. Configure your username, password, Anchore URL and cluster name in the [values file](https://github.com/anchore/anchore-charts/tree/master/stable/kai/values.yaml).

```
  # Path should not be changed, cluster value is used to tell Anchore which cluster this inventory is coming from
  kubeconfig:
    cluster: <unique-name-for-your-cluster>

  anchore:
    url: <URL for your>

    # Note: reccommend using the inventory-agent role
    user: <user>
    password: <password>
```

2. Run helm install in the cluster(s) you wish to track 
```
$ helm repo add anchore https://charts.anchore.io
$ helm install <release> -f <values.yaml> anchore/kai
``` 

Kai must be able to resolve the Anchore URL and requires API credentials. Review the kai logs if you are not able to see the inventory results in the UI. 

Note: the Anchore API Password can be provided via a kubernetes secret, or injected into the environment of the `kai` container
* For injecting the environment variable, see: `inject_secrets_via_env`
* For providing your own secret for the Anchore API Password, see: `kai.existing_secret`. `kai` creates it's own secret based on your values.yaml file for key `kai.anchore.password`, but the `kai.existingSecret` key allows you to create your own secret and provide it in the values file.

## Agentless mode

In addition to running as agent kai can also be run by Anchore Enterpise in an embedded mode. In this mode `kai` runs within the Anchore Enterprise, and needs a cluster configuration to access the Kubernetes API. This still requires cluster but allows for monitoring without the installation of additional components. See more details about setting up [embedded mode](./embedded/). 

## CLI and API Inventory Collection
In situations where you may not be able to have consitent network connection `kai` along with the inventory API can be used to collect and report inventory back to Anchore Enterprise. Inventory collection can also be used to collect other types of containers runtimes however non are officially supported at this time. 

### Usage
To quickly verify that you are tracking Kubernetes Inventory you can quickly access inventory results from the `anchorectl` with the  command `anchorectl inventory list`. The UI for the Kubernetes allows operators to visually navigate vulnerability resultes, source where vulnerabilties come from and apply their default policy to thier runtime. You'll be able to subscribe to changes for your clusters, quicky asses vulnerabilities and more.

For more details about watching clusters, and reviewing policy results see the [Using Kubernetes Inventory](/docs/using/ui_usage/kubernetes/) section.





