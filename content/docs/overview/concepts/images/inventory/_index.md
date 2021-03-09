---
title: "Image Runtime Inventory"
linkTitle: "Image Inventory"
weight: 1
---

Anchore can connect to your runtime environment and discern which images exist in each context (i.e. Kubernetes Namespace).

Currently, supported runtime environments include:
* Kubernetes

# Kubernetes Runtime Inventory 
## Configuration
Anchore uses a go binary called [kai](https://github.com/anchore/kai) that leverages the [Kubernetes Go SDK](https://github.com/kubernetes/client-go) to reach out and list
pods in a configurable set of namespaces to determine which images are running.

This binary is installed into the Enterprise Docker Image and can be configured using the REST API, but depends on Anchore knowing your cluster configuration and corresponding credentials. On the other hand, `kai` can also be run via it's helm chart, embedded within your Kubernetes cluster as an agent. In this run-mode, it will require access to the Anchore API.  

## Embedded mode

In embedded mode, `kai` runs within the Enterprise Image, and needs a cluster configuration to access the Kubernetes API.

Authentication with the Kubernetes API can be done similarly to how a kubeconfig is configured. Anchore supports either a Service Account token (recommended) or a client private key/certificate combination.

### Generating a Service Account Token
To generate a Service Account token with the necessary permissions (view), follow these steps:
1. Create a Service Account: `$ kubectl create serviceaccount <name> -n <namespace>`
    * ex. `$ kubectl create serviceaccount anchore-runtime-inventory -n default`
1. Bind the Service Account to a Role: `$ kubectl create clusterrolebinding <binding-name> --clusterrole=view --serviceaccount=<namespace>:<name>`
    * ex. `$ kubectl create clusterrolebinding anchore-runtime-inventory-binding --clusterrole=view --serviceaccount=default:anchore-runtime-inventory`
1. Get the token name: ```$ TOKENNAME=`kubectl -n <namespace> get serviceaccount/<name> -o jsonpath='{.secrets[0].name}'` ```
    * ex. ```$ TOKENNAME=`kubectl -n default get serviceaccount/anchore-runtime-inventory -o jsonpath='{.secrets[0].name}'` ```
1. Get the token value, which corresponds to the "credential" field below: ```$ TOKEN=`kubectl -n <namespace> get secret $TOKENNAME -o jsonpath='{.data.token}'` ```
    * ex. ```$ TOKEN=`kubectl -n default get secret $TOKENNAME -o jsonpath='{.data.token}'` ```

The endpoints for configuring the cluster within Anchore are documented under the Enterprise Swagger route, but are also demonstrated below:
```shell script
$ cat kai-demo-cluster.json
{
	"cluster_name": "docker-desktop-token",
	"inventory_type": "kubernetes",
	"cluster_config": {
		"cluster_certificate": "ABC", # redacted
		"cluster_server": "https://kubernetes.docker.internal:6443",
		"credential": "XYZ", #redacted
		"credential_type": "token",
		"namespaces": [
			"all"
		]
	}
}
$ curl -X POST -u admin:foobar -H "Content-Type: application/json" --data-binary "@kai-demo-cluster.json" "http://localhost:8228/v1/enterprise/inventories/clusters"
```
Some of the fields above within the `cluster_config` correspond to fields you would see in your kubeconfig:
* **cluster_certificate:** corresponds to `clusters[0].cluster.certificate-authority-data`
* **cluster_server:** corresponds to `clusters[0].cluster.server`
* **credential:** corresponds to either a service account token or the private key of a user. Note: if a private key is supplied, then a **client_certificate** must also be specified. 
    * The private key may be found at `users[0].user.client-key-data`.
    * The token, if included in a kubeconfig, would be found at `users[0].user.token`
* **client_certificate:** (required only for private key authentication), corresponds to `users[0].user.client-certificate-data`
* **credential_type:** values can either be "token" or "private_key" 
* **namespaces:** configures which namespaces anchore will pull a runtime inventory from

#### Example

Consider this kubeconfig, which has both a service-account-token authenticated user as well as a private_key-authenticated user:
```
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: abc
    server: https://kubernetes.docker.internal:6443
  name: docker-desktop
contexts:
- context:
    cluster: docker-desktop
    user: docker-desktop
  name: docker-desktop
current-context: docker-desktop
kind: Config
preferences: {}
users:
- name: docker-desktop
  user:
    client-certificate-data: def
    client-key-data: ghi
- name: kai-demo
  user:
    token: jkl
```

The corresponding Cluster Config JSON for the Service Account Token authentication would be:
```json
{
	"cluster_name": "docker-desktop-token",
	"inventory_type": "kubernetes",
	"cluster_config": {
		"cluster_certificate": "abc",
		"cluster_server": "https://kubernetes.docker.internal:6443",
		"credential": "jkl",
		"credential_type": "token",
		"namespaces": [
			"all"
		]
	}
}
```

The corresponding Cluster Config JSON for the private_key authentication would be:
```json
{
	"cluster_name": "docker-desktop-private-key",
	"inventory_type": "kubernetes",
	"cluster_config": {
		"cluster_certificate": "abc",
		"cluster_server": "https://kubernetes.docker.internal:6443",
        "client_certificate": "def",
		"credential": "ghi",
		"credential_type": "private_key",
		"namespaces": [
			"all"
		]
	}
}
```

### Usage
Once a cluster is configured, Anchore will execute the kai binary on an interval, parse the JSON output, and then store the current snapshot of the inventory.
That inventory may be listed by running HTTP GET on `/v1/enterprise/inventories`.

To configure the interval on which the kai binary runs, adjust the value of the `ANCHORE_CATALOG_K8S_INVENTORY_REPORT_INTERVAL_SEC` environment variable on the enterprise catalog service. By default, it runs every 5 minutes.

Clusters may be retrieved in list format via HTTP GET on `/v1/enterprise/inventories/clusters` or by name, with HTTP GET on `v1/enterprise/inventories/clusters/<name>`
They may also be deleted via HTTP DELETE on `/v1/enterprise/inventories/clusters/<name>`. Once the cluster is removed, inventory will no longer be reported.

## External Mode

If you would prefer to not provide Kubernetes API access to Anchore directly, `kai` can be configured to run as an agent within your cluster via a helm chart, and can also run on it's own as a CLI tool (for more information about the CLI itself, head over to the [kai repo](https://github.com/anchore/kai).

`kai`'s helm chart is hosted as part of the https://charts.anchore.io repo. It is based on the [anchore/kai](https://hub.docker.com/r/anchore/kai) docker image. 

To install the helm chart, follow these steps:
```
$ helm repo add anchore https://charts.anchore.io
$ helm install <release> -f <values.yaml> anchore/kai
``` 
An example values file can be found [here](https://github.com/anchore/anchore-charts/tree/master/stable/kai/values.yaml).

The key configurations are in the `kai.anchore` section. Kai must be able to resolve the Anchore URL and requires API credentials.

Note: the Anchore API Password can be provided via a kubernetes secret, or injected into the environment of the `kai` container
* For injecting the environment variable, see: `inject_secrets_via_env`
* For providing your own secret for the Anchore API Password, see: `kai.existing_secret`. `kai` creates it's own secret based on your values.yaml file for key `kai.anchore.password`, but the `kai.existingSecret` key allows you to create your own secret and provide it in the values file.

# Image Time-To-Live
As part of reporting images in your runtime environment, Anchore maintains an active record of that set of images based on when the Image has been last reported by `kai`.

If `kai` does not find an image that was previously in the inventory, it waits for a configurable TTL to expire before removing that image:

```yaml
services:
  catalog:
    runtime_inventory:
      image_ttl_days: 120
```

By default a runtime inventory image's TTL is set to 120 days. That means, that if `kai` hasn't seen your image in it's configured contexts for more than 4 months, it will be removed from the active working inventory image set (no longer returned from `GET /v1/enterprise/inventories`)

Image TTL can be disabled, if you only want `/v1/enterprise/inventories` to return a recent set of active images, just set the value of `runtime_inventory.image_ttl_days` to `-1`. If set to `-1`, then the `/v1/enterprise/inventories` API will always show the latest inventory reported by `kai`.
