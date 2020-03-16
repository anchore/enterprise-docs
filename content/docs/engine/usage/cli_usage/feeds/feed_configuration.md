---
title: "Feed Configuration"
linkTitle: "Configuration"
weight: 1
---

### Feed Synchronization Interval

The default configuration for the Anchore Engine will download vulnerability data from Anchore's feed service every 21,600 seconds (6hours).

For most users the only configuration option that is typically updated is the feed synchronization interval - the time interval (in seconds) at which the feed sync is run.

```policy_engine:
    .....
    
    cycle_timers:
      ...
      feed_sync: 14400
```

### Feed Settings

In the default Anchore configuration file, config.yaml, the feed settings are commented out and the Anchore Engine will use the default settings.

The Anchore Engine will default to downloading feed data from Anchore's feed service hosted at https://ancho.re/v1/services/feeds

This service requires authentication and the system includes default credential for an anonymous user.

The Anchore Engine will by default only synchronize vulnerability data such as CVE information. The Anchore Feed service also provide package data from NPM Package registry and Ruby Gems registry which can be used as part of policy checks which check Node and Ruby package names and versions, as well as non-os vulnerability data from National Vulnerability Data (NVD) which can be used to perform non-os package vulnerability scans.

By default the Anchore Engine will perform a selective sync enabling only the vulnerabilities feed. Setting the (selective_sync) enabled flag to false, or updating the other feed types to True will enable synchronization of the specified feed.

```
feeds:
  selective_sync:
    # If enabled only sync specific feeds instead of all.
    enabled: True
    feeds:
      vulnerabilities: True
      packages: False
      nvd: True
  anonymous_user_username: anon@ancho.re
  anonymous_user_password: pbiU2RYZ2XrmYQ
  url: 'https://ancho.re/v1/service/feeds'
  client_url: 'https://ancho.re/v1/account/users'
  token_url: 'https://ancho.re/oauth/token'
  connection_timeout_seconds: 3
  read_timeout_seconds: 60
```

Note: The package and nvd data feeds are large, resulting in the initial sync taking some time time, and will use in excess of 2GB of memory.

During initial feed sync, you can always query the progress and status of the feed sync using the anchore-cli.

```
anchore-cli system feeds list
Feed                   Group                  LastSync                           RecordCount        
nvd                    nvddb:2002             2018-06-08T12:10:08.933467Z        6745               
nvd                    nvddb:2003             2018-06-08T12:10:06.822104Z        1546               
...
...
vulnerabilities        alpine:3.3             2018-06-08T17:28:53.876964Z        457                
vulnerabilities        alpine:3.4             2018-06-08T12:09:30.389172Z        594                
...
...
```
