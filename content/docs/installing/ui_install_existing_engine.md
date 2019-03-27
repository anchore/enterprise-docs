---
title: "Enterprise UI as client against existing Anchore Engine"
weight: 1
---

Before installation please verify that all necessary requirements have been fulfilled including installation and configuration of the Open Source Anchore Engine.  

### Running Enterprise UI against existing Anchore Engine installation

In the following example an Anchore Engine is already installed and accessible at the following URL http://anchore.example.com:8228/v1

We will create a Redis service as part of the installation.

### 1. Create a directory to publish as a configuration volume to the Anchore Enterprise UI container

```
# mkdir ~/aevolume.ui
# mkdir ~/aevolume.ui/config
```

### 2. Set up your configuration, docker-compose and license files

Download the attached config-ui.yaml file and edit, adding your anchore-engine URL endpoint.  Save this file as ~/aevolume.ui/config/config-ui.yaml.  The contents of the config-ui.yaml are as follows:

```
# URL of Anchore Engine
engine_uri: 'http://<your_anchore_engine_hostname>:8228/v1'

# URI of redis endpoint
redis_url: 'redis://anchore-redis:6379'

# The (optional) `rbac_uri` key specifies the address of the Role-Based
# Authentication Control (RBAC) service. The value must be a string containing a
# properly-formed 'http' or 'https' URI, and can be overridden by using the
# `ANCHORE_RBAC_URI` environment variable.
#
# Note that the presence of an uncommented `rbac_uri` key in this file (even if
# unset, or set with an invalid value) instructs the Anchore Enterprise UI web
# service that the RBAC feature *must* be enabled.
#
# If the RBAC service cannot subsequently be reached by the web service, the
# communication failure will be handled in the same manner as an Anchore Engine
# service outage.
#
# rbac_uri: 'http://anchore-enterprise:8229/v1'


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
| rbac_url | The (optional) `rbac_uri` key specifies the address of the Role-Based Authentication Control (RBAC) service. The value must be a string containing a properly-formed 'http' or 'https' URI, and can be overridden by using the `ANCHORE_RBAC_URI` environment variable. |

Next, download the attached docker-compose.yaml, and copy it as ~/aevolume.ui/docker-compose.yaml.  This file should be left unmodified, but if you have any special requirements (for example, updating the Anchore Enterprise UI image version) or advanced configuration, you can review and edit the file before starting up the UI.

Finally, copy your license file, as-is, named ~/aevolume.ui/config/license.yaml

Once these steps are complete, your ~/aevolume.ui/ workspace should now look like this:

```
# cd ~/aevolume.ui
# find .
.
./config
./config/config-ui.yaml
./config/license.yaml
./docker-compose.yaml
#
```

### 3. Download and Run the Enterprise UI

Using docker-compose from the directory container docker-compose.yaml

```
# cd ~/aevolume.ui
# docker login
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username: <your_dockerhub_account>
Password: <your_dockerhub_password>
# docker-compose pull
# docker-compose up -d
```

### 4. Start using the UI

You can point your browser at the Anchore Enterprise UI by directing it to http://<your_ui_hostname>:3000/ (e.g. http://localhost:3000/), and logging in with any valid anchore-engine username and password.

![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36012163806/original/w33QY2tQaGM_aaGOANOlfGOXw9d9XYTUgg.jpg?1532547051)

To stop the Anchore Enterprise UI container, you can always do so with docker-compose:

```
# cd ~/aevolume.ui
# docker-compose down --volumes
```

### 5. Next Steps

Now that the Anchore Enterprise UI is up and running, you can use it to navigate your anchore engine images, generate overview/compliance/security reports, inspect image contents, changelogs, and build artifacts, inspect anchore-engine INFO and ERROR events, configure registry credentials, manage anchore policies, edit/tune/test anchore policies, and more.

### Troubleshooting

Most errors and issues that might arise with the UI are presented via the UI itself, but if for any reason you are having trouble bringing up the UI for the first time, or at any point wish to review the system for critical issues, the best source of information is the logging output of the UI container that can be accessed using standard docker logs interface:

```
# cd ~/aevolume.ui
# docker-compose logs anchore-ui
```