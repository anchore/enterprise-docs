---
title: "Database Driver"
weight: 1
---

The default archive driver is the PostgreSQL database driver which stores all archive documents within the PostgreSQL database.

Compression is not supported for this driver since the underlying database will handle compression.

There are no configuration options required for the Database driver.

The sample [config.yaml](https://raw.githubusercontent.com/anchore/anchore-engine/master/scripts/docker-compose/config.yaml) file includes the default configuration for the archive driver.

```YAML
archive:
      compression:
        enabled: False
        min_size_kbytes: 100
      storage_driver:
        name: db
        config: {}
```

