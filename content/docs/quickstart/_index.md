---
title: "Quickstart"
linkTitle: "Quickstart"
weight: 2
---

## Introduction

In this section, you'll learn how to get up and running with a stand-alone Anchore Enterprise installation for trial, demonstration, and review with [Docker Compose](https://docs.docker.com/compose/install/).  If you are specifically looking for a quickstart for Anchore Engine OSS alone, please jump to [Anchore Engine Quickstart](/docs/engine/engine_installation/docker_compose/).

**Note:** If your intent is to gain a deeper understanding of Anchore and its concepts, we recommend navigating to the [Overview](/docs/overview) section prior to conducting an [installation](/docs/installation) of Anchore Enterprise.

## Requirements

The following instructions assume you are using a system running Docker v1.12 or higher, and a version of Docker Compose that supports at least v2 of the docker-compose configuration format.

* A stand-alone installation will requires at least 4GB of RAM, and enough disk space available to support the largest container images you intend to analyze (we recommend 3x largest container image size).  For small images/testing (basic Linux distro images, database images, etc), between 5GB and 10GB of disk space should be sufficient.  
* In order to access the Anchore Enterprise, you will also require a valid `license.yaml` file that has been issued to you by Anchore.  If you do not have a license yet, visit this page for instructions on how to request one.


### Step 1: Setup installation location

Create a directory in which to store your configuration files and license file.
```
mkdir ~/aevolume
```

### Step 2: Copy configuration files

Download the latest Anchore Enterprise container image, which contains the necessary `docker-compose.yaml` and configuration files that will be used for the deployment.   In order to be able to download the container, you'll need to login to docker (if you are not logged in already) using the dockerhub account that you provided to Anchore when you requested your license.

```
# docker login
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username: <your_dockerhub_account>
Password: <your_dockerhub_password>

# docker pull docker.io/anchore/enterprise:latest
```

Next, copy the included docker-compose.yaml to the ~/aevolume/ directory.

```
# docker create --name ae docker.io/anchore/enterprise:latest
# docker cp ae:/docker-compose.yaml ~/aevolume/docker-compose.yaml
# docker rm ae
```

Finally, copy the license.yaml file that was provided to you into the ~/aevolume/ directory.

```
# cp /path/to/your/license.yaml ~/aevolume/license.yaml
```

Once these steps are complete, your ~/aevolume/ workspace should now look like this:

```
# cd ~/aevolume
# find .
.
./docker-compose.yaml
./license.yaml
```

### Step 3: Download and run the containers

Download the containers listed in the `docker-compose.yaml`, and run the entire setup using the docker-compose CLI.  
NOTE: by default, all services (including a bundled DB instance) will be transient, and data will be lost if you shut down/restart 

```
# cd ~/aevolume
# docker-compose pull
# docker-compose up -d
```

### Step 4: Verify service availability

After a few moments (depending on system speed), your Anchore Engine, Anchore Enterprise, and Anchore UI services should be up and running, ready to use.  You can verify the containers are running with docker-compose:

```
# cd ~/aevolume
# docker-compose ps
                Name                               Command               State           Ports         
-------------------------------------------------------------------------------------------------------
aevolume_anchore-db_1                   docker-entrypoint.sh postgres    Up      5432/tcp              
aevolume_anchore-gems-db_1              docker-entrypoint.sh postgres    Up      5432/tcp              
aevolume_engine-analyzer_1              /docker-entrypoint.sh anch ...   Up      8228/tcp              
aevolume_engine-api_1                   /docker-entrypoint.sh anch ...   Up      0.0.0.0:8228->8228/tcp
aevolume_engine-catalog_1               /docker-entrypoint.sh anch ...   Up      8228/tcp              
aevolume_engine-policy-engine_1         /docker-entrypoint.sh anch ...   Up      8228/tcp              
aevolume_engine-simpleq_1               /docker-entrypoint.sh anch ...   Up      8228/tcp              
aevolume_enterprise-feeds_1             /docker-entrypoint.sh anch ...   Up      0.0.0.0:8448->8228/tcp
aevolume_enterprise-rbac-authorizer_1   /docker-entrypoint.sh anch ...   Up      8089/tcp, 8228/tcp    
aevolume_enterprise-rbac-manager_1      /docker-entrypoint.sh anch ...   Up      0.0.0.0:8229->8228/tcp
aevolume_enterprise-ui-redis_1          docker-entrypoint.sh redis ...   Up      6379/tcp              
aevolume_enterprise-ui_1                /bin/sh -c node /home/node ...   Up      0.0.0.0:3000->3000/tcp
```

You can run a command to get the status of the Anchore Engine services:



```
# cd ~/aevolume
# docker-compose exec engine-api anchore-cli system status
Service policy_engine (anchore-quickstart, http://engine-policy-engine:8228): up
Service rbac_authorizer (anchore-quickstart, http://enterprise-rbac-authorizer:8228): up
Service rbac_manager (anchore-quickstart, http://enterprise-rbac-manager:8228): up
Service simplequeue (anchore-quickstart, http://engine-simpleq:8228): up
Service catalog (anchore-quickstart, http://engine-catalog:8228): up
Service analyzer (anchore-quickstart, http://engine-analyzer:8228): up
Service apiext (anchore-quickstart, http://engine-api:8228): up

Engine DB Version: 0.0.8
Engine Code Version: 0.3.0-dev
```

**Note:** The first time you run Anchore Enterprise, it will take some time (10+ minutes, depending on network speed) for the vulnerability data to get synced into the engine.  For the best experience, wait until the core vulnerability data feeds have completed before proceeding.  You can check the status of your feed sync using the CLI:

```
# cd ~/aevolume
# docker-compose exec engine-api anchore-cli system feeds list
Feed                   Group                  LastSync                           RecordCount        
vulnerabilities        alpine:3.3             2018-06-27T17:13:53.509309Z        457                
vulnerabilities        alpine:3.4             2018-06-27T17:13:59.103245Z        594                
vulnerabilities        alpine:3.5             2018-06-27T17:14:05.000942Z        649                
vulnerabilities        alpine:3.6             2018-06-27T17:14:10.606606Z        632                
vulnerabilities        alpine:3.7             2018-06-27T17:14:17.673851Z        767                
vulnerabilities        centos:5               2018-06-27T17:14:46.616051Z        1270               
vulnerabilities        centos:6               2018-06-27T17:15:18.600668Z        1266               
vulnerabilities        centos:7               2018-06-27T17:15:41.468527Z        657                
vulnerabilities        debian:10              2018-06-27T17:18:16.960078Z        17494              
vulnerabilities        debian:7               2018-06-27T17:21:20.058941Z        20455              
vulnerabilities        debian:8               None                               0                  
vulnerabilities        debian:9               None                               0                  
vulnerabilities        debian:unstable        None                               0                  
vulnerabilities        ol:5                   None                               0                  
vulnerabilities        ol:6                   None                               0                  
vulnerabilities        ol:7                   None                               0                  
vulnerabilities        ubuntu:12.04           None                               0                  
vulnerabilities        ubuntu:12.10           None                               0                  
vulnerabilities        ubuntu:13.04           None                               0                  
vulnerabilities        ubuntu:14.04           None                               0                  
vulnerabilities        ubuntu:14.10           None                               0                  
vulnerabilities        ubuntu:15.04           None                               0                  
vulnerabilities        ubuntu:15.10           None                               0                  
vulnerabilities        ubuntu:16.04           None                               0                  
vulnerabilities        ubuntu:16.10           None                               0                  
vulnerabilities        ubuntu:17.04           None                               0                  
vulnerabilities        ubuntu:17.10           None                               0                  
vulnerabilities        ubuntu:18.04           None                               0                  
```

As soon as you see RecordCount values > 0 for all vulnerability groups, the system is fully populated and ready to present vulnerability results.   Note that feed syncs are incremental, so the next time you start up Anchore Enterprise it will be ready immediately.

### Step 5: Start using Anchore

To get started, you can add a few images to Anchore Engine using the CLI. Once this is done, you can also run an additional CLI command to monitor the analysis state of the added images, waiting until the images move into an 'analyzed' state.

```
# cd ~/aevolume
# docker-compose exec engine-api anchore-cli image add docker.io/library/alpine:latest
...
...

# docker-compose exec engine-api anchore-cli image add docker.io/library/nginx:latest
...
...

# docker-compose exec engine-api anchore-cli image list
Full Tag                               Image ID                                                                Analysis Status        
docker.io/library/alpine:latest        3fd9065eaf02feaf94d68376da52541925650b81698c53c6824d92ff63f98353        analyzed               
docker.io/library/nginx:latest         5699ececb21caf07b92cbda9daa1e965407e3793a72000ecbf6b8e8595a0824a        analyzing

# docker-compose exec engine-api anchore-cli image list
Full Tag                               Image ID                                                                Analysis Status        
docker.io/library/alpine:latest        3fd9065eaf02feaf94d68376da52541925650b81698c53c6824d92ff63f98353        analyzed               
docker.io/library/nginx:latest         5699ececb21caf07b92cbda9daa1e965407e3793a72000ecbf6b8e8595a0824a        analyzed                       
```


Now that some images are in place, you can point your browser at the Anchore Enterprise UI by directing it to _http://localhost:3000/_.  

Enter the username _admin_ and password _foobar_ to log in.  There, you will be able to navigate your images, inspect image contents, perform security scans, review compliance policy evaluations, edit compliance policies with a complete policy editor UI, manage accounts/users/RBAC assignments, and review system events (and other UI features).

**Note:** This document is intended to serve as a quickstart guide. Before moving further with Anchore Enterprise, it is highly recommended that you enhance your learning by reading the [Overview](/docs/getting_started/) sections to gain a deeper understanding of fundamentals, concepts, and proper usage. 

### Next Steps

Now that you have Anchore Enterprise running, you can begin to learning more about Anchore Enterprise Architecture, Anchore Concepts and Anchore Usage.

- To learn more about Anchore Enterprise, go to [Overview](/docs/overview/)
- To learn more about Anchore Concepts, go to [Concepts](/docs/overview/concepts)
- To learn more about other installation methods, go to [Installation](/docs/installation)
- To learn more about using Anchore Usage, go to [Usage](/docs/using/)