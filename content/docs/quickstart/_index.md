---
title: "Quickstart"
linkTitle: "Quickstart"
weight: 1
---

## Introduction

In this section, you'll learn how to get up and running with a stand-alone Anchore Enterprise installation for trial, demonstration, and review with [Docker Compose](https://docs.docker.com/compose/install/). If you are specifically looking for a quickstart for Anchore Engine OSS alone, please jump to [Anchore Engine Quickstart]({{< ref "/docs/engine/quickstart" >}}).

**Note:** If your intent is to gain a deeper understanding of Anchore and its concepts, we recommend navigating to the [Overview]({{< ref "/docs/overview" >}}) section prior to conducting an [installation]({{< ref "/docs/installation" >}}) of Anchore Enterprise.


## Configuration Files for this Quickstart:

* [Docker Compose File](./docker-compose.yaml)

* (Optional) [Prometheus Configuration for Monitoring](./anchore-prometheus.yml). See [Enabling Prometheus Monitoring]({{< ref "#optional-enabling-prometheus-monitoring" >}})

* (Optional) [Swagger UI Nginx Proxy](./anchore-swaggerui-nginx.conf) to browse the API with a Swagger UI. See [Enabling Swagger UI]({{< ref "#optional-enabling-swagger-ui" >}})


## Requirements

The following instructions assume you are using a system running Docker v1.12 or higher, and a version of Docker Compose that supports at least v2 of the docker-compose configuration format.

* A stand-alone installation requires at least 4GB of RAM, and enough disk space available to support the largest container images you intend to analyze (we recommend 3x largest container image size).  For small images/testing (like basic Linux distro images or database images), between 5GB and 10GB of disk space should be sufficient.
* To access the Anchore Enterprise, you need a valid `license.yaml` file that has been issued to you by Anchore.  If you do not have a license yet, visit this [page](https://info.anchore.com/contact) for instructions on how to request one.


### Step 1: Ensure you can authenticate to DockerHub to pull the images

You'll need authenticated access to the `anchore/enterprise` and `anchore/enterprise-ui` repositories on DockerHub. Anchore support should have granted your DockerHub user access when you received your license.

```
# docker login
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username: <your_dockerhub_account>
Password: <your_dockerhub_password>
```

### Step 2: Download compose, copy license, and start.

Now, ensure the license.yaml file you got from Anchore Sales/Support is in the directory where you want to run the containers from, then download the compose file and start it.
You can use the link at the top of this page, or use curl or wget to download it as shown below.

```
# cp <path/to/your/license.yaml> ./license.yaml
# curl https://docs.anchore.com/current/docs/quickstart/docker-compose.yaml > docker-compose.yaml
# docker-compose up -d
```

### Step 3: Verify service availability

After a few moments (depending on system speed), your Anchore Engine, Anchore Enterprise, and Anchore UI services should be up and running, ready to use.  You can verify the containers are running with docker-compose:

```
# docker-compose ps
             Name                           Command                  State               Ports         
-------------------------------------------------------------------------------------------------------
anchorequickstart_analyzer_1          /docker-entrypoint.sh anch ...   Up (healthy)   8228/tcp              
anchorequickstart_anchore-db_1        docker-entrypoint.sh postgres    Up             5432/tcp              
anchorequickstart_api_1               /docker-entrypoint.sh anch ...   Up (healthy)   0.0.0.0:8228->8228/tcp
anchorequickstart_catalog_1           /docker-entrypoint.sh anch ...   Up (healthy)   8228/tcp              
anchorequickstart_notifications_1     /docker-entrypoint.sh anch ...   Up (healthy)   0.0.0.0:8668->8228/tcp
anchorequickstart_policy-engine_1     /docker-entrypoint.sh anch ...   Up (healthy)   8228/tcp              
anchorequickstart_queue_1             /docker-entrypoint.sh anch ...   Up (healthy)   8228/tcp              
anchorequickstart_rbac-authorizer_1   /docker-entrypoint.sh anch ...   Up (healthy)   8089/tcp, 8228/tcp    
anchorequickstart_rbac-manager_1      /docker-entrypoint.sh anch ...   Up (healthy)   0.0.0.0:8229->8228/tcp
anchorequickstart_reports_1           /docker-entrypoint.sh anch ...   Up (healthy)   0.0.0.0:8558->8228/tcp
anchorequickstart_ui-redis_1          docker-entrypoint.sh redis ...   Up             6379/tcp              
anchorequickstart_ui_1                /docker-entrypoint.sh node ...   Up             0.0.0.0:3000->3000/tcp
```

You can run a command to get the status of the Anchore Engine services:

```
# docker-compose exec api anchore-cli system status
Service rbac_manager (anchore-quickstart, http://rbac-manager:8228): up
Service apiext (anchore-quickstart, http://api:8228): up
Service analyzer (anchore-quickstart, http://analyzer:8228): up
Service simplequeue (anchore-quickstart, http://queue:8228): up
Service catalog (anchore-quickstart, http://catalog:8228): up
Service reports (anchore-quickstart, http://reports:8228): up
Service notifications (anchore-quickstart, http://notifications:8228): up
Service rbac_authorizer (anchore-quickstart, http://rbac-authorizer:8228): up
Service policy_engine (anchore-quickstart, http://policy-engine:8228): up

Engine DB Version: 0.0.4
Engine Code Version: 2.3.0

```

**Note:** The first time you run Anchore Enterprise, it will take some time (10+ minutes, depending on network speed) for the vulnerability data to get synced into the engine.  For the best experience, wait until the core vulnerability data feeds have completed before proceeding.  You can check the status of your feed sync using the CLI:

```
# docker-compose exec api anchore-cli system feeds list
Feed                   Group                  LastSync                          RecordCount        
github                 github:composer        pending                           None               
github                 github:gem             pending                           None               
github                 github:java            pending                           None               
github                 github:npm             pending                           None               
github                 github:nuget           pending                           None               
github                 github:python          pending                           None               
nvdv2                  nvdv2:cves             pending                           None               
vulnerabilities        alpine:3.10            2020-04-27T19:49:45.186409        1725               
vulnerabilities        alpine:3.11            2020-04-27T19:49:59.993730        1904               
vulnerabilities        alpine:3.3             2020-04-27T19:50:16.213013        457                
vulnerabilities        alpine:3.4             2020-04-27T19:50:20.128136        681                
vulnerabilities        alpine:3.5             2020-04-27T19:50:25.876762        875                
vulnerabilities        alpine:3.6             2020-04-27T19:50:33.361682        1051               
vulnerabilities        alpine:3.7             2020-04-27T19:50:42.354798        1395               
vulnerabilities        alpine:3.8             2020-04-27T19:50:54.311199        1486               
vulnerabilities        alpine:3.9             2020-04-27T19:51:07.340326        1558               
vulnerabilities        amzn:2                 2020-04-27T19:51:20.726861        327                
vulnerabilities        centos:5               2020-04-27T19:51:31.586422        1347               
vulnerabilities        centos:6               2020-04-27T19:51:57.345700        1403               
vulnerabilities        centos:7               2020-04-27T19:52:26.350592        1063               
vulnerabilities        centos:8               2020-04-27T19:52:59.187517        215                
vulnerabilities        debian:10              2020-04-27T19:53:08.194067        22580              
vulnerabilities        debian:11              2020-04-27T19:56:03.833415        19681              
vulnerabilities        debian:7               2020-04-27T19:58:44.907852        20455              
vulnerabilities        debian:8               pending                           12500              
vulnerabilities        debian:9               pending                           None               
vulnerabilities        debian:unstable        pending                           None               
vulnerabilities        ol:5                   pending                           None               
vulnerabilities        ol:6                   pending                           None               
vulnerabilities        ol:7                   pending                           None               
vulnerabilities        ol:8                   pending                           None               
vulnerabilities        rhel:5                 pending                           None               
vulnerabilities        rhel:6                 pending                           None               
vulnerabilities        rhel:7                 pending                           None               
vulnerabilities        rhel:8                 pending                           None               
vulnerabilities        ubuntu:12.04           pending                           None               
vulnerabilities        ubuntu:12.10           pending                           None               
vulnerabilities        ubuntu:13.04           pending                           None               
vulnerabilities        ubuntu:14.04           pending                           None               
vulnerabilities        ubuntu:14.10           pending                           None               
vulnerabilities        ubuntu:15.04           pending                           None               
vulnerabilities        ubuntu:15.10           pending                           None               
vulnerabilities        ubuntu:16.04           pending                           None               
vulnerabilities        ubuntu:16.10           pending                           None               
vulnerabilities        ubuntu:17.04           pending                           None               
vulnerabilities        ubuntu:17.10           pending                           None               
vulnerabilities        ubuntu:18.04           pending                           None               
vulnerabilities        ubuntu:18.10           pending                           None               
vulnerabilities        ubuntu:19.04           pending                           None               
vulnerabilities        ubuntu:19.10           pending                           None               
vulnerabilities        ubuntu:20.04           pending                           None

```

As soon as you see RecordCount values set for all vulnerability groups, the system is fully populated and ready to present vulnerability results.   Note that feed syncs are incremental, so the next time you start up Anchore Enterprise it will be ready immediately.  The CLI tool includes a useful utility that will block until the feeds have completed a successful sync:

```
# docker-compose exec api anchore-cli system wait
Starting checks to wait for anchore-engine to be available timeout=-1.0 interval=5.0
API availability: Checking anchore-engine URL (http://localhost:8228)...
API availability: Success.
Service availability: Checking for service set (catalog,apiext,policy_engine,simplequeue,analyzer)...
Service availability: Success.
Feed sync: Checking sync completion for feed set (vulnerabilities)...
Feed sync: Checking sync completion for feed set (vulnerabilities)...
...
...
Feed sync: Success.

```

### Step 4: Start using Anchore

To get started, you can add a few images to Anchore Engine using the CLI. Once complete, you can also run an additional CLI command to monitor the analysis state of the added images, waiting until the images move into an 'analyzed' state.

```
# docker-compose exec api anchore-cli image add docker.io/library/alpine:latest
...
...

# docker-compose exec api anchore-cli image add docker.io/library/nginx:latest
...
...

# docker-compose exec api anchore-cli image list
Full Tag                               Image Digest                                                                   Analysis Status        
docker.io/library/alpine:latest        sha256:39eda93d15866957feaee28f8fc5adb545276a64147445c64992ef69804dbf01        analyzed               
docker.io/library/nginx:latest         sha256:cccef6d6bdea671c394956e24b0d0c44cd82dbe83f543a47fdc790fadea48422        analyzing              

# docker-compose exec api anchore-cli image wait docker.io/library/nginx:latest
...
...

# docker-compose exec api anchore-cli image list
Full Tag                               Image Digest                                                                   Analysis Status        
docker.io/library/alpine:latest        sha256:39eda93d15866957feaee28f8fc5adb545276a64147445c64992ef69804dbf01        analyzed               
docker.io/library/nginx:latest         sha256:cccef6d6bdea671c394956e24b0d0c44cd82dbe83f543a47fdc790fadea48422        analyzed               

```


Now that some images are in place, you can point your browser at the Anchore Enterprise UI by directing it to _http://localhost:3000/_.

Enter the username _admin_ and password _foobar_ to log in.  These are some of the features you can use in the browser:

- Navigate images
- Inspect image contents
- Perform security scans
- Review compliance policy evaluations
- Edit compliance policies with a complete policy editor UI
- Manage accounts, users, and RBAC assignments
- Review system events

**Note:** This document is intended to serve as a quickstart guide. Before moving further with Anchore Enterprise, it is highly recommended to read the [Overview]({{< ref "/docs/overview" >}}) sections to gain a deeper understanding of fundamentals, concepts, and proper usage.

### Enabling Windows Image Support

To enable scanning of Windows images, you'll have to configure more of the system to deploy a feed service and setup the proper drivers to collect vulnerability data for Windows.


See: [Enabling Windows]({{< ref "/docs/quickstart/enabling_windows" >}})

### Next Steps

Now that you have Anchore Enterprise running, you can begin to learn more about Anchore Enterprise Architecture, Anchore Concepts, and Anchore Usage.

- To learn more about Anchore Enterprise, go to [Overview]({{< ref "/docs/overview" >}})
- To learn more about Anchore Concepts, go to [Concepts]({{< ref "/docs/overview/concepts" >}})
- To learn more about other installation methods, go to [Installation]({{< ref "/docs/installation" >}})
- To learn more about using Anchore Usage, go to [Usage]({{< ref "/docs/using" >}})


### Optional: Enabling Prometheus Monitoring

1. Uncomment the following section at the bottom of the docker-compose.yaml file:

    ```
    #  # Uncomment this section to add a prometheus instance to gather metrics. This is mostly for quickstart to demonstrate prometheus metrics exported
    #  prometheus:
    #    image: docker.io/prom/prometheus:latest
    #    depends_on:
    #      - api
    #    volumes:
    #      - ./anchore-prometheus.yml:/etc/prometheus/prometheus.yml:z
    #    logging:
    #      driver: "json-file"
    #      options:
    #        max-size: 100m
    #    ports:
    #      - "9090:9090"
    #
    ```

1. For each service entry in the docker-compose.yaml, change the following to enable metrics in the API for each service

    ```
    ANCHORE_ENABLE_METRICS=false
    ```

    to

    ```
    ANCHORE_ENABLE_METRICS=true
    ```

1. Download the example prometheus configuration into the same directory as the docker-compose.yaml file, with name _anchore-prometheus.yml_

    ```
    curl https://docs.anchore.com/current/docs/quickstart/anchore-prometheus.yml > anchore-prometheus.yml
    docker-compose up -d
    ```

    You should see a new container started and can access prometheus via your browser on `http://localhost:9090`


### Optional: Enabling Swagger UI

1. Uncomment the following section at the bottom of the docker-compose.yaml file:

    ```
    #  # Uncomment this section to run a swagger UI service, for inspecting and interacting with the anchore engine API via a browser (http://localhost:8080 by default, change if needed in both sections below)
    #  swagger-ui-nginx:
    #    image: docker.io/nginx:latest
    #    depends_on:
    #      - api
    #      - swagger-ui
    #    ports:
    #      - "8080:8080"
    #    volumes:
    #      - ./anchore-swaggerui-nginx.conf:/etc/nginx/nginx.conf:z
    #    logging:
    #      driver: "json-file"
    #      options:
    #        max-size: 100m
    #  swagger-ui:
    #    image: docker.io/swaggerapi/swagger-ui
    #    environment:
    #      - URL=http://localhost:8080/v1/swagger.json
    #    logging:
    #      driver: "json-file"
    #      options:
    #        max-size: 100m
    ```

1. Download the nginx configuration into the same directory as the docker-compose.yaml file, with name _anchore-swaggerui-nginx.conf_

    ```
    curl https://docs.anchore.com/current/docs/engine/quickstart/anchore-swaggerui-nginx.conf > anchore-swaggerui-nginx.conf
    docker-compose up -d
    ```

    You should see a new container started and can access swagger UI via your browser on `http://localhost:8080`
