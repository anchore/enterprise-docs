---
title: "Install with Docker Compose"
weight: 1
---

The Anchore Engine can be run using Docker Compose. A sample Docker Compose file is provided that runs both the Anchore Engine and PostgreSQL database as containers.

1. Set up a working directory for your configuration and data volumes.

```
# mkdir ~/aevolume
# mkdir ~/aevolume/config
# mkdir ~/aevolume/db
# cd ~/aevolume
```

2. Download the [docker-compose.yaml](https://raw.githubusercontent.com/anchore/anchore-engine/master/scripts/docker-compose/docker-compose.yaml) and [config.yaml](https://raw.githubusercontent.com/anchore/anchore-engine/master/scripts/docker-compose/config.yaml) files from the scripts/docker-compose directory of the github project. 

```
# curl https://raw.githubusercontent.com/anchore/anchore-engine/master/scripts/docker-compose/docker-compose.yaml -o ~/aevolume/docker-compose.yaml
# curl https://raw.githubusercontent.com/anchore/anchore-engine/master/scripts/docker-compose/config.yaml -o ~/aevolume/config/config.yaml
```

3. Your ~/aevolume directory should now look like this: 

```
# cd ~/aevolume
# find .
.
./config
./config/config.yaml
./db
./docker-compose.yaml
```

4. (Optional) Review the default docker-compose.yaml and config.yaml files to modify any particular settings for your environment (not necessary for quickstart).

5. Run `docker-compose pull` to instruct Docker to download the required container images from DockerHub.
    `docker-compose pull`

6. Start Anchore Engine
    Note: This command should be run from the directory container docker-compose.yaml.
    `docker-compose up -d`

7. Verify that your DB and service containers are up and then run an anchore-cli command to verify system status: 

```
# docker-compose ps
          Name                         Command               State                       Ports                     
-------------------------------------------------------------------------------------------------------------------
aevolume_anchore-db_1       docker-entrypoint.sh postgres    Up      5432/tcp                                      
aevolume_anchore-engine_1   /bin/sh -c /usr/bin/anchor ...   Up      0.0.0.0:8228->8228/tcp, 0.0.0.0:8338->8338/tcp

# docker-compose exec anchore-engine anchore-cli --u admin --p foobar system status
Service simplequeue (dockerhostid-anchore-engine, http://anchore-engine:8083): up
Service apiext (dockerhostid-anchore-engine, http://anchore-engine:8228): up
Service kubernetes_webhook (dockerhostid-anchore-engine, http://anchore-engine:8338): up
Service analyzer (dockerhostid-anchore-engine, http://anchore-engine:8084): up
Service policy_engine (dockerhostid-anchore-engine, http://anchore-engine:8087): up
Service catalog (dockerhostid-anchore-engine, http://anchore-engine:8082): up

Engine DB Version: 0.0.8
Engine Code Version: 0.3.0
```

8. The first time you run anchore-engine, it will take some time to perform its initial data feed sync (vulnerability data download).  Subsequently, anchore-engine will only sync data changes and thus you will only have to wait the very first time you start the engine.  You can watch the status of your feed sync with anchore-cli:mmand to verify system status: 

```
# docker-compose exec anchore-engine anchore-cli --u admin --p foobar system feeds list
Feed                   Group                  LastSync                           RecordCount        
vulnerabilities        alpine:3.3             2018-11-06T22:41:32.151772Z        457                
vulnerabilities        alpine:3.4             2018-11-06T22:41:38.110987Z        594                
vulnerabilities        alpine:3.5             2018-11-06T22:41:46.316811Z        857                
vulnerabilities        alpine:3.6             2018-11-06T22:41:55.170845Z        871                
vulnerabilities        alpine:3.7             2018-11-06T22:42:04.039058Z        889                
vulnerabilities        alpine:3.8             2018-11-06T22:42:13.644172Z        972                
vulnerabilities        centos:5               2018-11-06T22:42:43.967110Z        1322               
vulnerabilities        centos:6               2018-11-06T22:43:15.459474Z        1307               
vulnerabilities        centos:7               2018-11-06T22:43:43.976151Z        726                
vulnerabilities        debian:10              None                               0                  
vulnerabilities        debian:7               None                               0                  
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

As soon as all the feeds show a non-zero RecordCount , then the feeds are all synced and the system is ready to generate vulnerability reports.  You can add images right away, but you will not see any vulnerability scan results until the vulnerability data feeds are synced.

9. Start using the anchore-engine service to analyze images - a short example follows:

```
# docker-compose exec anchore-engine anchore-cli --u admin --p foobar image add 
docker.io/library/debian:7
# docker-compose exec anchore-engine anchore-cli --u admin --p foobar image get docker.io/library/debian:7 | grep 'Analysis Status'
Analysis Status: analyzing

# docker-compose exec anchore-engine anchore-cli --u admin --p foobar image get docker.io/library/debian:7 | grep 'Analysis Status'
Analysis Status: analyzing

# docker-compose exec anchore-engine anchore-cli --u admin --p foobar image get docker.io/library/debian:7 | grep 'Analysis Status'
Analysis Status: analyzed

# docker-compose exec anchore-engine anchore-cli --u admin --p foobar image vuln docker.io/library/debian:7 all
Vulnerability ID        Package                                  Severity          Fix         Vulnerability URL                                                 
CVE-2005-2541           tar-1.26+dfsg-0.1+deb7u1                 Negligible        None        https://security-tracker.debian.org/tracker/CVE-2005-2541         
CVE-2007-5686           login-1:4.1.5.1-1+deb7u1                 Negligible        None        https://security-tracker.debian.org/tracker/CVE-2007-5686         
CVE-2007-5686           passwd-1:4.1.5.1-1+deb7u1                Negligible        None        https://security-tracker.debian.org/tracker/CVE-2007-5686         
CVE-2007-6755           libssl1.0.0-1.0.1t-1+deb7u4              Negligible        None        https://security-tracker.debian.org/tracker/CVE-2007-6755         
...
...
...

# docker-compose exec anchore-engine anchore-cli --u admin --p foobar evaluate check docker.io/library/debian:7
Image Digest: sha256:92d507d81bd3b0459b121215f6f9d8249bb154c8b65e041942745dcc6309a7b5
Full Tag: docker.io/library/debian:7
Status: pass
Last Eval: 2018-11-06T22:51:47Z
Policy ID: 2c53a13c-1765-11e8-82ef-23527761d060
```

10. Stopping the Anchore Engine 
    *Note:* This command should be run from the directory containing docker-compose.yaml

    `docker-compose down --volumes`