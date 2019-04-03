---
title: "Enterprise UI and Anchore Engine co-located"
linkTitle: "Co-Located Install"
weight: 2
---

## Introduction

Before installation please verify that all necessary requirements have been fulfilled including installation and configuration of the Open Source Anchore Engine.  

### Running Enterprise UI and Anchore Engine co-located, using a single docker-compose.yaml

In the following example, we'll demonstrate how to add an Anchore Enterprise UI to an existing Anchore Engine installation, by modifying the existing docker-compose.yaml that is being used to run Anchore Engine.

### 1. Set up configuration location

We assume for this example that there is an existing configuration location that is being used for an existing anchore engine installation: 

```
# cd ~/aevolume
# find .
.
./config
./config/config.yaml
./db
./workspace
./docker-compose.yaml
```

### 2. Set up your configuration, docker-compose and license files

Download the attached config-ui.yaml file and save this file as ~/aevolume/config/config-ui.yaml.  The contents of the config-ui.yaml are as follows:

```
# URL of Anchore Engine
engine_uri: 'http://anchore-engine:8228/v1'

# URL
redis_url: 'redis://anchore-redis:6379'

# Specifies if SSL is enabled in the web app container
enable_ssl: False

# Specifies whether to trust a reverse proxy
enable_proxy: False
```

| Parameter | Details |
| :------ | :----------- |
| engine_url | URL of the Anchore Engine including port and v1 uri. eg. http://<your_anchore_engine_hostname>:8228/v1 |
| redis_url | URL of the Redis Server that the Anchore UI will use to store session data. Note: URL prefix should be redis:// |
| enable_ssl | If The Anchore UI should server SSL/TLS pages. Anchore Recommends using a reverse proxy, load balancer or other ingress controller to terminate SSL for production installation, but otherwise this value should be left set to False. |
| enable_proxy | Specifies whether to trust a reverse proxy when setting secure cookies via the "X-Forwarded-Proto" header). SSL must be enabled for this to work and a reverse proxy/load balancer/other ingress conroller must be installed and configured.  Otherwise, this value should be left set to False. |

Next, edit your existing ~/aevolume/docker-compose.yaml file, and add service definitions for both the UI and redis service containers:

```
...
...
services:
...
...
  anchore-ui:
    image: docker.io/anchore/enterprise-ui:latest
    depends_on:
     - anchore-engine
     - anchore-redis
    ports:
    - "3000:3000"
    volumes:
     - ./config:/config/:z
  anchore-redis:
    image: docker.io/library/redis:4
    logging:
     driver: "json-file"
     options:
      max-size: 100m
...
...
...
```

Finally, copy your license file, as-is, named ~/aevolume/config/license.yaml

Once these steps are complete, your ~/aevolume/ workspace should now look like this:

```
# cd ~/aevolume
# find .
.
./config
./config/config.yaml
./config/config-ui.yaml
./config/license.yaml
./db
./workspace
./docker-compose.yaml
#
```

### 3. Download and Run your co-located Anchore Engine and Enterprise UI services

Using docker-compose from the directory containing docker-compose.yaml:

```
# cd ~/aevolume
# docker login
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username: <your_dockerhub_account>
Password: <your_dockerhub_password>
# docker-compose pull
# docker-compose up -d
```

### 4. Start using the UI

You can point your browser at the Anchore Enterprise UI by directing it to http://<your_ui_hostname>:3000/ (e.g. http://localhost:3000/), and logging in with any valid anchore-engine username and password.

![alt text](/ui-login-screen.jpg)
