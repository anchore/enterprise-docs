---
title: "Running Anchore Enterprise in an Air-Gapped Environment"
linkTitle: "Air-Gapped"
weight: 4
---

Anchore Enterprise can run in an isolated environment with no outside internet connectivity. It does require a network connection to its own components and must be able to reach the Docker image registries (v2 API compatible) where the images to be analyzed are hosted.

![alt text](air-gapped.jpg)

### Components

1. Private Network
2. Public Network (internet is reachable)
3. Anchore Enterprise Feeds
4. Anchore Enterprise Feeds in Read-Only Mode
5. Anchore Engine
6. Docker Image Registry (any registry that is compatible with the Docker Registry v2 API)

### Assumptions

1. The docker images to be analyzed are available within the Private Network
2. Anchore Engine will be accessed from within the private network by the components in the infrastructure that need to query for analysis results
3. There exists a way to move a data file from the Public Network to the Private Network

### Installation

1. Refer to feed data migration for configuring a Read-Only Feeds in Private Network
2. Install Anchore Engine in Private Network
3. Configure the Engine to use the Read-Only 4. Feeds installation, see configuration
4. Start Anchore Engine


### Periodically Updating Feed Data

To ensure that the Anchore Engine installation has up-to-date vulnerability data from the vulnerability sources, you need to update the Read-Only Feed Service with data from the feed service running on the public network. This is essentially the same process that was used at installation to initialize the Read-Only Feed Service, and should be done on a regular schedule or when the Public Network Feed Service task execution indicates new data was detected.