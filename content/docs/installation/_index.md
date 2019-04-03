---
title: "Installing Anchore Enterprise"
linkTitle: "Installing"
weight: 4
---

Anchore Enterprise and its components are delivered as Docker container images which can be deployed co-located or full distributed or anything in-between, and as such it can scale out to increase analysis throughput. The only external system required is a PostgreSQL database (9.6+) that all service connect to, but do not use for communication beyond some very simple service registration/lookup processes. The database is centralized simply for ease of management and operation. For more information on the architecture, go to [Anchore Enterprise Arcitecture](/docs/overview/architecture).

Jump to the installation guide of your choosing:

- [Docker Compose](/docs/installation/docker_compose)
- [Kubernetes](/docs/installation/helm)