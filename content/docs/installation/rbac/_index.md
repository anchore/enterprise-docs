---
title: "Configuring RBAC"
linkTitle: "RBAC"
weight: 4
---

## Introduction

In the two primary ways to run Anchore Enterprise out-of-the-box, the enterprise quickstart's docker-compose or the anchore-engine helm chart, RBAC is configured and enabled by default if you enable the enterprise features.

This document will cover a from-scratch configuration of an Anchore Engine deployment to use RBAC. For the sake of simplicity, this document will cover how to modify the config.yaml for the necessary services in order to use RBAC. This document will not cover overall installation or deployment topologies. For information that, see Deploying Anchore Enterprise.

The services that need extra configuration in order to enable RBAC are:
- Anchore Engine external API service (apiext)
- Anchore Enterprise RBAC Manager

### Assumptions

1. You have access to the Anchore Enterprise docker image and have a valid license.yaml issue by Anchore Inc. If you don't have one and would like a trial, please contact us.
2. You have a running Anchore Engine Open Source installation, for example from the Anchore Engine quickstart
3. You're comfortable on the Linux command line and editing yaml documents. Nothing advanced, just some simple moving files around and editing text.

#### Option 1: Engine Quickstart & Update docker-compose.yaml

The update process can be accomplished by updating the `docker-compose.yaml`. If you're using the Helm Chart or another deployment mechanism, the updates to the docker-compose should be instructive of what to add, and where to connect the services.

If you are using the `docker-compose.yaml` provided in the Anchore Engine quickstart, then you can simply replace it with the enterprise version:

```
docker pull anchore/enterprise:1.2
docker create --name ent
docker cp ent:/docker-compose.yaml .
docker rm ent
cp <path_to>/license.yaml .
docker-compose up -d
```

This will add the new services as well as the Enterprise Feeds service and the Enterprise UI, and basically starts the system as outlined in the Anchore Enterprise Quickstart Guide

#### Option 2: Anchore Engine Helm Chart for Kubernetes

The chart provides a set of flags to enable to use Enterprise, and RBAC is configured by default when those are set.

The flags are:
1. anchoreEnterpriseGlobal.enabled=true
2. anchoreEnterpriseRbac.enabled=true

This will have the effect of adding some containers to the anchoreAPI deployment pods that run the RBAC Manager and RBAC Authorizer services as well as configuring the api endpoints to use the authorizer correctly.

**NOTE:** if you have already installed anchore and have created accounts and users, enabling RBAC will cause all non-admin users to have no permissions or API access to authorization-gated routes (most API calls) until you explicitly assign each user one or more roles. The configuration and install process for RBAC does *not* automatically assign roles to existing users.

#### Option 3: Manual Configuration

See: Manual Configuration of RBAC for more information on this process and the steps involved.