---
title: "Manual Configuration of RBAC Mode for Upgrading Anchore Engine to Enterprise"
linkTitle: "RBAC Configuration"
weight: 2
---

## Introduction

The process to upgrade from Anchore Engine to RBAC-enabled Anchore Enterprise involves a few steps. The following steps are general guidelines and may need to be modified for your specific installation requirements and environment.

For these steps, the assumption is that all containers and services are running on the same local host, extending this config to support distributed deployment or orchestration systems is an exercise left to the reader. For Kubernetes deployments, we recommend using the Anchore Engine Helm chart which has support built-in for upgrading a deployment from open-source to enterprise features.

### Assumptions for this guide:

1. You have access to the Anchore Enterprise docker image and have a valid license.yaml issue by Anchore Inc. If you don't have one and would like a trial, please contact us.
2. You have a running Anchore Engine Open Source installation, for example from the Anchore Engine quickstart
3. You're comfortable on the linux command line and editing yaml documents. Nothing advanced, just some simple moving files around and editing text.
4. All anchore engine services are running on the same localhost
5. The license.yaml file is available on the local host
5. The default config.yaml provided in the open-source container (anchore/anchore-engine:latest) is being used and not externally mounted in to the containers.

### Configuring RBAC:

1. Stop all containers
2. Modify the configuration of the apiext service to set the authorization_handler native to external and provide a authorization_handler_config section with a single key: endpoint that provides the url for the RBAC authorizer service. This step can be skipped if you are using the default configs packaged with the anchore-engine container and enterprise containers. In that case you'll simply be setting some environment variables for the containers.

    1. Using the default bundled config.yaml in the container:
        1. Set the environment vars:
            1. ANCHORE_AUTHZ_HANDLER=external
            2. ANCHORE_EXTERNAL_AUTHZ_ENDPOINT=http://enterprise-rbac-authorizer:8228
    2. For custom config.yaml files
        1. NOTE: this must be set on *all* user-facing api services: the Engine API and RBAC Manager. The on-prem feed service is not a user-facing API and is neither authenticated nor authorized since it is a read-only API, so no RBAC configuration is necessary for that service.

        ```YAML
        services:
          apiext:
            ...
            authorization_handler: external
            authorization_handler_config:
              endpoint: "http://enterprise-rbac-authorizer:8228"
        ```
    3. Run the rbac_manager service to provide and API for configuring roles and membership. In this example, we'll map the internal port 8228 to the host's port 8229 so that users can access it via that 8229 port.
        1. `docker run -d --name enterprise-rbac-manager --p 8229:8228 -v license.yaml:/license.yaml anchore/enterprise:latest anchore-enterprise-manager service start rbac_manager`

    4. Run the rbac_authorizer service, accessible only to the rbac_manager and apiext services (possibly two different instances if necessary), to provide authorization decisions. Note that in this execution, the port is not exposed on the host, only available to other containers running, which will use the default port, 8228 to contact the authorizer.
        1. `docker run -d --name enterprise-rbac-authorizer -v license.yaml:/license.yaml anchore/enterprise:latest anchore-enterprise-manager service start rbac_authorizer`
