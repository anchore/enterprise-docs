---
title: "Trouble Shooting"
linkTitle: "Trouble Shooting"
weight: 7
---

This guide will walkthrough some general troubleshooting tips with your Anchore Engine instance. When troubleshooting Anchore Engine, the recommend approach is to first verify all Anchore services are up, use the event subsystem to narrow down particular issues, and then navigate to the logs for specific services to find out more information.

If you are running into issues performing certain Anchore operations (examples: images are failing analysis or cannot access a private registry) please consult the [FAQs]({{< ref "/docs/troubleshooting/faqs" >}}) document.

Throughout this guide, Anchore CLI commands will be executed to assist with troubleshooting. For more information on the Anchore CLI, please reference the CLI section.

* [Verifying Services]({{< ref "#verifying-services" >}})
* [Events]({{< ref "#events" >}})
* [Logs]({{< ref "#logs" >}})
* [Removing a Repository and Images]({{< ref "#removing-repo-images" >}})

## Verifying Healthy Service Status

There is a minimum set of anchore service components that must be running for a deployment to be functional:

- Service analyzer
- Service policy_engine
- Service catalog
- Service apiext
- Service simplequeue

You can verify which services have registered themselves successfully, along with their status, by running: `anchore-cli system status`

```
# anchore-cli system status
Service analyzer (anchore-quickstart, http://engine-analyzer:8228): up
Service apiext (anchore-quickstart, http://engine-api:8228): up
Service catalog (anchore-quickstart, http://engine-catalog:8228): up
Service policy_engine (anchore-quickstart, http://engine-policy-engine:8228): up
Service simplequeue (anchore-quickstart, http://engine-simpleq:8228): up

Engine DB Version: 0.0.12
Engine Code Version: 0.6.0
```

An Anchore Enterprise deployment will show additional services, and also includes a system health control in the Anchore Enterprise UI with additional service status information:

```
# anchore-cli system status
Service analyzer (anchore-quickstart, http://engine-analyzer:8228): up
Service apiext (anchore-quickstart, http://engine-api:8228): up
Service catalog (anchore-quickstart, http://engine-catalog:8228): up
Service policy_engine (anchore-quickstart, http://engine-policy-engine:8228): up
Service simplequeue (anchore-quickstart, http://engine-simpleq:8228): up
Service rbac_authorizer (anchore-quickstart, http://enterprise-rbac-authorizer:8228): up
Service notifications (anchore-quickstart, http://enterprise-notifications:8228): up
Service reports (anchore-quickstart, http://enterprise-reports:8228): up
Service rbac_manager (anchore-quickstart, http://enterprise-rbac-manager:8228): up

Engine DB Version: 0.0.12
Engine Code Version: 0.6.0

```

**Note:** If specific services are down, you can investigate the logs for the services. See [Logs Section]({{< ref "#logs" >}})

### The --debug and --json options

Passing the `--debug` option to any Anchore CLI can often help narrow down particular issues, by displaying the API calls that are being made from the CLI tool to the anchore engine itself.

```
# Example system status with --debug

# anchore-cli --debug system status
INFO:anchorecli.clients.apiexternal:As Account = None
DEBUG:urllib3.connectionpool:Starting new HTTP connection (1): localhost:8228
DEBUG:urllib3.connectionpool:http://localhost:8228 "GET / HTTP/1.1" 200 5
INFO:anchorecli.clients.apiexternal:As Account = None
DEBUG:anchorecli.clients.apiexternal:GET url=http://localhost:8228/system
DEBUG:anchorecli.clients.apiexternal:GET insecure=True
DEBUG:urllib3.connectionpool:Starting new HTTP connection (1): localhost:8228
DEBUG:urllib3.connectionpool:http://localhost:8228 "GET /system HTTP/1.1" 200 2672
DEBUG:anchorecli.cli.utils:fetched httpcode from response: 200
Service analyzer (dockerhostid-anchore-engine, http://anchore-engine:8084): up
Service policy_engine (dockerhostid-anchore-engine, http://anchore-engine:8087): up
Service catalog (dockerhostid-anchore-engine, http://anchore-engine:8082): up
Service apiext (dockerhostid-anchore-engine, http://anchore-engine:8228): up
Service simplequeue (dockerhostid-anchore-engine, http://anchore-engine:8083): up
```

Passing the `--json` option to any Anchore CLI commands will output the direct API response data in JSON format, which often contains much more information than what the CLI outputs by default, for both regular successful operations and for operations that are resulting in an error:

```
# anchore-cli --json system status
{
    "service_states": [
        {
            "base_url": "http://anchore-engine:8087",
            "hostid": "dockerhostid-anchore-engine",
            "service_detail": {
                "available": true,
                "busy": false,
                "db_version": "0.0.9",
                "detail": {},
                "message": "all good",
                "up": true,
                "version": "0.3.4"
            },
            "servicename": "policy_engine",
            "status": true,
            "status_message": "available",
            "version": "v1"
        },
        ...
    ]
}
```

## Events

If you've successfully verified that all of the Anchore Engine services are up, but are still running into issues operating Anchore a good place check is the event log.

The event log subsystem provides users with a mechanism to inspect asynchronous event occurring across various Anchore Engine services. Anchore events include periodically triggered activities such as vulnerability data feed sync in the policy_engine service, image analysis failures originating from the analyzer service, and other informational or system fault events. The catalog service may also generate events for any repositories or image tags that are being watched, when Anchore Engine encounters connectivity, authentication, authorization or other errors in the process of checking for updates.

The event log is aimed at troubleshooting most common failure scenarios (especially those that happen during asynchronous engine operations) and to pinpoint the reasons for failures, that can be used subsequently to help with corrective actions. Events can be cleared from Anchore Engine in bulk or individually.

### Viewing Events

Running the following command will give a list of recent Anchore events: `anchore-cli event list`

```
# Viewing list of recent Anchore events

# anchore-cli event list
Timestamp                          Level        Service              Host                      Event                                               ID                                      
2019-12-06T22:39:53.184796Z        info         catalog              anchore-quickstart        user.checks.tag.vulnerabilities.update              ee907dc6a20247fba341a0bfc979a0f9        
2019-12-06T22:39:51.885110Z        info         catalog              anchore-quickstart        user.checks.tag.vulnerabilities.update              90fd5ec7338d4b8e8d8a278ef7708023        
2019-12-06T22:38:39.346023Z        info         policy_engine        anchore-quickstart        system.feeds.sync.completed                         28ddf4dd66ff4c1d8b601090381e3f1d        
2019-12-06T22:38:39.150163Z        info         policy_engine        anchore-quickstart        system.feeds.sync.feed_completed                    fba3317da77b486e985773f8740ef1df        
2019-12-06T22:38:38.965768Z        info         policy_engine        anchore-quickstart        system.feeds.sync.group_completed                   4cc60c304d054495866b60de84d9f5bc        
2019-12-06T22:38:38.307436Z        info         policy_engine        anchore-quickstart        system.feeds.sync.group_started                     0d363ab4aed44423b3d1a1f611ec0feb
2019-12-06T22:37:48.262320Z        info         policy_engine        anchore-quickstart        system.feeds.sync.feed_started                      3984eb6be001448d93f8e1613264ce98        
2019-12-06T22:37:45.354266Z        info         policy_engine        anchore-quickstart        system.feeds.sync.started                           b97b85298e3b46a39c949af05414810c        
2019-12-06T22:37:44.731710Z        info         analyzer             anchore-quickstart        user.image.analysis.completed                       8fa1923fb8cf46f5857d41bb25370f55        
2019-12-06T22:37:44.731706Z        info         analyzer             anchore-quickstart        user.image.analysis.completed                       f099456bc3804412a1a0888d5319258c        
2019-12-06T22:37:44.731701Z        info         analyzer             anchore-quickstart        user.image.analysis.completed                       f8a03725821a4c76956c0257f51789a5        
2019-12-06T22:36:44.550372Z        info         analyzer             anchore-quickstart        user.image.analysis.completed                       1dbe720e2c0c4743ac590ea0529c323f        
2019-12-06T22:36:44.550361Z        info         analyzer             anchore-quickstart        user.image.analysis.completed                       f0d6f130334b4f309fdac7ed8c8e0b68        
2019-12-06T22:36:06.866451Z        error        catalog              anchore-quickstart        system.image_analysis.registry_lookup_failed        58e32e697d194002b661a9e42bd775a5        
...
...
...
```

### Details about a specific event

If you would like more information about a specific event, you can run the following command: `anchore-cli event get <event-id>`

```
# Details about a specific Anchore event

# anchore-cli event get b97b85298e3b46a39c949af05414810c
details:
  sync_feed_types:
  - vulnerabilities
  - nvdv2
level: info
message: Feeds sync task started
resource:
  id: null
  type: feeds
  user_id: admin
source:
  base_url: http://engine-policy-engine:8228
  hostid: anchore-quickstart
  request_id: null
  servicename: policy_engine
timestamp: '2019-12-06T22:37:45.354266Z'
type: system.feeds.sync.started
```

**Note:** Depending on the output from the detailed events, looking into the logs for a particular servicename (example: policy_engine) is the next troubleshooting step.  

## Logs

Anchore services produce detailed logs that container information about user interactions, internal processes, warnings and errors.  The verbosity of the logs is controlled using the log_level setting in config.yaml (for manual installations) or the corresponding ANCHORE_LOG_LEVEL environment variable (for docker-compose or Helm installations) for each service.  The log levels are DEBUG, INFO, WARN, ERROR, and FATAL, where the default is INFO.  Most of the time, the default level is sufficient as the logs will container warn, error and fatal messages as well, but for deep troubleshooting, it is always recommended to increase the log level to DEBUG in order to ensure the availability of the maximum amount of information.

Anchore logs can be accessed by inspecting the docker logs for any anchore service container using the regular docker logging mechanisms, which typically default to displaying to the stdout/stderr of the containers themselves - for example:

```
# docker ps
...
33c809f1803a        anchore/anchore-engine:latest       "/docker-entrypoint.…"   22 hours ago        Up 22 hours (healthy)   8228/tcp                         aevolume_engine-catalog_1
...

# docker logs aevolume_engine-analyzer_1
[service:worker] 2019-12-06 00:54:20+0000 [-] [MainThread] [anchore_engine.twisted/makeService()] [INFO] Initializing configuration
[service:worker] 2019-12-06 00:54:20+0000 [-] [MainThread] [anchore_engine.twisted/makeService()] [INFO] Initializing logging
[service:worker] 2019-12-06 00:54:20+0000 [-] [MainThread] [anchore_engine.service/initialize()] [DEBUG] Invoking instance-specific handler registration
[service:worker] 2019-12-06 00:54:20+0000 [-] [MainThread] [anchore_engine.service/_register_instance_handlers()] [INFO] Registering api handlers
[service:worker] 2019-12-06 00:54:20+0000 [-] [MainThread] [anchore_engine.service/_process_stage_handlers()] [INFO] Processing init handlers for bootsrap stage: pre_config
[service:worker] 2019-12-06 00:54:20+0000 [-] [MainThread] [anchore_engine.service/_process_stage_handlers()] [DEBUG] Executing 0 stage pre_config handlers
[service:worker] 2019-12-06 00:54:20+0000 [-] [MainThread] [anchore_engine.service/_configure()] [INFO] Loading and initializing global configuration
[service:worker] 2019-12-06 00:54:20+0000 [-] [MainThread] [anchore_engine.service/_configure()] [INFO] Configuration complete
...
...

```

The logs themselves are also persisted as logfiles inside the anchore service containers.  Executing a shell into any Anchore service container and navigating to `/var/log/anchore`, you will find the service log files.  For example, using the same analyzer container service as above:
```
# docker exec -t -i  aevolume_engine-analyzer_1 /bin/bash
[anchore@687818c10b93 anchore-engine]$ cat /var/log/anchore/anchore-worker.log 
2019-12-06 00:54:20+0000 [-] [MainThread] [anchore_engine.twisted/makeService()] [INFO] Initializing configuration
2019-12-06 00:54:20+0000 [-] [MainThread] [anchore_engine.twisted/makeService()] [INFO] Initializing logging
2019-12-06 00:54:20+0000 [-] [MainThread] [anchore_engine.service/initialize()] [DEBUG] Invoking instance-specific handler registration
2019-12-06 00:54:20+0000 [-] [MainThread] [anchore_engine.service/_register_instance_handlers()] [INFO] Registering api handlers
2019-12-06 00:54:20+0000 [-] [MainThread] [anchore_engine.service/_process_stage_handlers()] [INFO] Processing init handlers for bootsrap stage: pre_config
2019-12-06 00:54:20+0000 [-] [MainThread] [anchore_engine.service/_process_stage_handlers()] [DEBUG] Executing 0 stage pre_config handlers
2019-12-06 00:54:20+0000 [-] [MainThread] [anchore_engine.service/_configure()] [INFO] Loading and initializing global configuration
2019-12-06 00:54:20+0000 [-] [MainThread] [anchore_engine.service/_configure()] [INFO] Configuration complete
...
...

```

As stated above, if you are running into issues performing certain Anchore operations (examples: images are failing analysis or cannot access a private registry) please consult the [FAQs]({{< ref "/docs/troubleshooting/faqs" >}}) document.

## Removing a Repository and Images

There may be a time when you wish to stop a repository analysis when the analysis is running (e.g., accidentally watching an image with a large number of tags).  There are several steps in the process which can be found under [Removing a Repository and All Images]({{< ref "/docs/engine/usage/cli_usage/repositories/_index.md#removing-a-repository-and-all-images" >}}).

**Note:** Be careful when deleting images. In this flow, Anchore deletes the image, not just the repository/tag combo.  Because of this, deletes may impact more than the expected repository since an image may have tags in multiple repositories or even registries.


## Disabling feeds 
Once you have enabled feeds (nvd,vulndb etc) in the config file and deployed Anchore Engine , the only way to disable feeds is to delete the feed data from the DB (disabling them in the config.yaml file(conf/default_config.yaml) will not delete the existing data from the DB)

The following are the Database commands you need to run to delete feed data from the DB:
### to delete `nvd` feed from the DB:
```
DELETE  FROM feed_data_cpe_vulnerabilities WHERE feed_name='nvd';
DELETE FROM feed_data_nvd_vulnerabilities ;
```

### Delete `nvd2` feed from the DB:
```
DELETE  FROM feed_data_cpev2_vulnerabilities WHERE feed_name='nvdv2';
DELETE FROM feed_data_nvdv2_vulnerabilities ;
```

### Delete `gem` feed from the DB:
```
DELETE FROM feed_data_gem_packages ;
```

### Delete `npm` feed from the DB:
```
DELETE FROM feed_data_npm_packages ;
```

### Delete `vulndb` feed from the DB:
```
DELETE FROM feed_data_vulndb_vulnerabilities ;
```

**Note:** Make sure you have disabled the feeds you want deleted in the config.yaml file (conf/default_config.yaml), otherwise the feed data will be downloaded during the next Anchore Engine feed-sync.
