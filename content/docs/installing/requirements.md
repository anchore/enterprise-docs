---
title: "Anchore Enterprise Requirements"
weight: 1
---

The Anchore Enterprise User Interface is delivered as a Docker container that can be run on any Docker compatible runtime. 

The Anchore Enterprise UI module interfaces with Anchore Engine using the standard Anchore API endpoint. The UI does not require access to the Anchore Engine database, however a Redis server is used to store session information. 

- Runtime
    - Docker compatible runtime (version 1.12 or higher)

- Storage
    - Configuration volume This volume is used to provide persistent storage to the container from which it will read its configuration files and optionally certificates.
    Requirement: Less than 1MB

- Anchore Engine
    - A configured and operational Anchore Engine version 0.2.4 or higher. For installation instructions refer to the following link.

    **Note:** If the Anchore Engine has been configured to sync policies from the Anchore.IO service then you should disable the synchronization. In the credentials: section set the following option: auto_policy_sync: False

- Network
    - Ingress
        - The Anchore UI module publishes a web UI service by default on port 3000 however this port can be remapped.
    - Engress
        - The Anchore UI module requires access to two network services: 
            - Anchore Engine API end point (typically port 8228)
            - Redis Database (typically port 6379)

- Redis Service
    - Version 4 or higher

**Note:** If you're installing the Anchore Enterprise UI using our installation examples, they include a deployment of a redis service as part of the UI deployment process.