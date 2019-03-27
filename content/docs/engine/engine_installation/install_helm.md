---
title: "Install with Helm"
weight: 1
---

### Background
Helm is the package manager for Kubernetes, inspired by packaged managers such as homebrem, yum, npm and apt. Applications are packaged in Charts which are a collection of files that contain the definition and configuration of resources to be deployed to a Kubernetes cluster. Helm was created by Deis who donated the project to the Cloud Native Computing Foundation (CNCF).

Helm makes it simple to package and deploy applications to be deployed including versioning. upgrade and rollback of applications. Helm does not replace Docker images, in fact docker images are deployed by Helm into a kubernetes cluster.

Helm is comprised of two components a server side service running on the Kubernetes cluster called Tiller and the client side component, Helm. Using helm applications, packaged as charts, can be deployed and managed using a single command:

`helm install myApp`

### Requirements

The following guide requires:

- A running Kubernetes Cluster
- kubectl configured to access your Kubernetes cluster
- Helm binary installed and available in your path
- Tiller, the server side component of Helm, should be installed in your Kubernetes cluster. 

To installer Tiller run the following command:

```
$ helm init
$HELM_HOME has been configured at /home/username/.helm
Tiller (the Helm server-side component) has been installed into your Kubernetes Cluster.
⎈ Happy Helming! ⎈
```

If Tiller has already been installed you will receive a warning messaging that can safely be ignored.

### Installation

Next we need to ensure that we have an up to date list of Helm Charts.

```
$ helm repo update
Hang tight while we grab the latest from your chart repositories...
...Skip local chart repository
...Successfully got an update from the "stable" chart repository
Update Complete. ⎈ Happy Helming!⎈
```

By default, the Anchore Engine chart will deploy an Anchore Engine container along with a PostgreSQL database container however this behavior can be overridden if you have an existing PostgreSQL service available.

In addition to the database the chart creates two deployments:

- Cores Services: The core services deployment includes the external api, notification service, kubernetes webhook, catalog and queuing service.
- Worker: The worker service runs the image analysis and can be scaled up to handle concurrent evaluation of images.

In this example we will deploy the database, core services and a single worker. Please refer to the documentation for more sophisticated deployments including scaling worker nodes.

The installation can be completed with a single command:

`$ helm install --name anchore-demo stable/anchore-engine`

If there server side component, Tiller, is not installed you will see the following error message:

    Error: could not find tiller



In both examples the –name parameter is optional and if omitted a name will be randomly assigned to your deployment.

The Helm installation should complete in a matter of seconds after which time it will output details of the deployed resources showing the secrets, configMaps, volumes, services, deployments and pods that have been created.

In addition some further help text providing URLs and a quick start will be displayed.

Running helm list (or helm ls) will show your deployment

```
$ helm ls
NAME         REVISION UPDATED           STATUS   CHART                NAMESPACE
anchore-demo 1 Wed Jan 20 10:46:10 2018 DEPLOYED anchore-engine-0.1.0 default
```

We can use kubectl to show the deployments on the kubernetes cluster.

```
$ kubectl get deployments
NAME                                DESIRED CURRENT UP-TO-DATE AVAILABLE AGE
anchore-demo-anchore-engine-core    1       1       1          0         1m
anchore-demo-anchore-engine-worker  1       1       1          1         1m
anchore-demo-postgresql             1       1       1          1         1m
```

When the engine is started for the first time it will perform a full synchronization of feed data, including CVE vulnerability data. This first sync may last for several minutes during which time the Anchore Engine can analyze images but not perform policy evaluation or CVE reporting until successful completion of the feed sync.

The Anchore Engine exposes a REST API however the easiest way to interact with the Anchore Engine is through the Anchore CLI which can be installed using Python PiP.

`$ pip install anchorecli`

Documentation for installing the CLI can be found in following document.

The Anchore CLI can be configured using command line options, environment variables or a configuration file. See the CLI documentation for details.

In this example we will use environment variables.

```
ANCHORE_CLI_USER=admin
ANCHORE_CLI_PASS=foobar
```

The password can be retrieved from kubernetes by accessing the secrets passed to the container.

```
ANCHORE_CLI_PASS=$(kubectl get secret --namespace default anchore-demo-anchore-engine -o jsonpath="{.data.adminPassword}" | base64 --decode; echo)
```

Note: The deployment name in this example, anchore-demo-anchore-engine, was retrieved from the output of the helm installation or helm status command.

The helm installation or status command will also show the Anchore Engine URL, for example:

```
ANCHORE_CLI_URL=http://anchore-demo-anchore-engine.default.svc.cluster.local:8228/v1/
```

To provide external access you can use kubectl to expose the external API port, 8228 to the internet.

```
$ kubectl expose deployment anchore-demo-anchore-engine-core \
       --type=LoadBalancer \
       --name=anchore-engine \
       --port=8228 \
       service "anchore-engine" exposed
```

The external IP can be retrieved from the kubernetes cluster using the get service call:

```
$ kubectl get service anchore-engine

NAME           CLUSTER-IP   EXTERNAL-IP PORT(S)        AGE
anchore-engine 10.27.245.63 <pending>   8228:31622/TCP 22s
```

If the external IP is shown as pending then try re-running the command after a minute.

```
$ kubectl get service anchore-engine

NAME           CLUSTER-IP   EXTERNAL-IP    PORT(S)        AGE
anchore-engine 10.27.245.63 35.186.160.168 8228:31622/TCP 49s
```

In this example the Anchore URL should be set to:

`ANCHORE_CLI_URL=http://35.186.160.168:8228/v1`

Now you can use the Anchore CLI to analyze and report on images.
