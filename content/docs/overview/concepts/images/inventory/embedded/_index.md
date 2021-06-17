
---
title: "Embedded Mode"
linkTitle: "Embedded Mode"
weight: 1
---

## Agentless Inventory 
With the proper credentials Anchore Enterprise can use 'KAI' to collect inventory details from your cluster. 
Anchore supports storing either a Service Account token (recommended) or a client private key/certificate combination.

### Generating a Service Account Token
To generate a Service Account token for your cluster with the necessary permissions (view), follow these steps:
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
