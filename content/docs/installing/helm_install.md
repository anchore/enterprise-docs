---
title: "Deploying Anchore Enterprise 1.2 on Kubernetes using Helm"
weight: 1
---

New for Anchore Enterprise 1.2, the Anchore Engine official Helm chart now includes configuration options for a full Enterprise deployment. This deploys an Anchore Engine 0.3.0 system as well as the enterprise extensions and services.

1. Define a secret to store your docker pull credentials 

`kubectl create secret docker-registry anchore-enterprise-pullcreds --docker-username=user --docker-password=password --docker-email=email`

2. Define a secret to store your Enterprise License

`kubectl create secret generic anchore-enterprise-license --from-file license.yaml`

3. Create a new file: enterprise_values.yaml with the following content:

```YAML
anchoreEnterpriseGlobal:
  enabled: true
```

4. Deploy

`helm install stable/anchore-engine -f enterprise_values.yaml`

Also see the [README](https://github.com/helm/charts/tree/master/stable/anchore-engine/README.md) of the helm chart itself for more details on enabling specific features and providing secrets.