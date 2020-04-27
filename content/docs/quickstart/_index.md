---
title: "Quickstart"
linkTitle: "Quickstart"
weight: 1
---

## Introduction

In this section, you'll learn how to get up and running with a stand-alone Anchore Enterprise installation for trial, demonstration, and review with [Docker Compose](https://docs.docker.com/compose/install/). If you are specifically looking for a quickstart for Anchore Engine OSS alone, please jump to [Anchore Engine Quickstart]({{< ref "/docs/engine/quickstart" >}}).

The quickstart docker-compose.yaml file is available [here](./docker-compose.yaml)

**Note:** If your intent is to gain a deeper understanding of Anchore and its concepts, we recommend navigating to the [Overview]({{< ref "/docs/overview" >}}) section prior to conducting an [installation]({{< ref "/docs/installation" >}}) of Anchore Enterprise.

## Requirements

The following instructions assume you are using a system running Docker v1.12 or higher, and a version of Docker Compose that supports at least v2 of the docker-compose configuration format.

* A stand-alone installation will requires at least 4GB of RAM, and enough disk space available to support the largest container images you intend to analyze (we recommend 3x largest container image size).  For small images/testing (basic Linux distro images, database images, etc), between 5GB and 10GB of disk space should be sufficient.  
* In order to access the Anchore Enterprise, you will also require a valid `license.yaml` file that has been issued to you by Anchore.  If you do not have a license yet, visit this [page](https://info.anchore.com/contact) for instructions on how to request one.


### Step 1: Ensure you can authenticate to DockerHub to pull the images

You'll need authenticated access to the `anchore/enterprise` and `anchore/enterprise-ui` repositories on DockerHub. Anchore support should have granted your DockerHub user access when you received your license.

```
# docker login
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username: <your_dockerhub_account>
Password: <your_dockerhub_password>
```

### Step 2: Download compose, copy license and start.

 Now, ensure the license.yaml file you got from Anchore Sales/Support is in the directory where you want to run the containers from, then download the compose file and start it.
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

To get started, you can add a few images to Anchore Engine using the CLI. Once this is done, you can also run an additional CLI command to monitor the analysis state of the added images, waiting until the images move into an 'analyzed' state.

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

Enter the username _admin_ and password _foobar_ to log in.  There, you will be able to navigate your images, inspect image contents, perform security scans, review compliance policy evaluations, edit compliance policies with a complete policy editor UI, manage accounts/users/RBAC assignments, and review system events (and other UI features).

**Note:** This document is intended to serve as a quickstart guide. Before moving further with Anchore Enterprise, it is highly recommended that you enhance your learning by reading the [Overview]({{< ref "/docs/overview" >}}) sections to gain a deeper understanding of fundamentals, concepts, and proper usage. 

### Enabling Windows Image Support

To enable scanning of Windows images you'll have to configure more of the system to deploy a feed service and setup the proper drivers to collect vulnerability data for Windows.0


See: [Enabling Windows]({{< ref "/docs/quickstart/enabling_windows" >}})

### Next Steps

Now that you have Anchore Enterprise running, you can begin to learning more about Anchore Enterprise Architecture, Anchore Concepts and Anchore Usage.

- To learn more about Anchore Enterprise, go to [Overview]({{< ref "/docs/overview" >}})
- To learn more about Anchore Concepts, go to [Concepts]({{< ref "/docs/overview/concepts" >}})
- To learn more about other installation methods, go to [Installation]({{< ref "/docs/installation" >}})
- To learn more about using Anchore Usage, go to [Usage]({{< ref "/docs/using" >}})
