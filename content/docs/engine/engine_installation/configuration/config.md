---
title: "Configuration"
linkTitle: "General"
weight: 1
---

A single configuration file config.yaml is required to run the Anchore Engine - this file is typically passed to the Anchore Engine in a volume.  A default [config.yaml](https://raw.githubusercontent.com/anchore/anchore-engine/master/scripts/docker-compose/config.yaml) is provided as a way to get started, which is functional when combined with the default [docker-compose.yaml](https://raw.githubusercontent.com/anchore/anchore-engine/master/scripts/docker-compose/docker-compose.yaml), but many options are disabled by default and can be tuned to your liking.  Some useful initial configuration settings are mentioned here, where others are addressed in their own specific documentation sections throughout the anchore engine documentation.

1. Default admin credentials: in the example below the built in user *admin* has a password of *foobar*.

```YAML
default_admin_password: 'foobar'
default_admin_email: 'admin@myanchore'
```

2. Vulnerability data feeds: by default, anchore engine is configured to only automatically sync the 'vulnerability' data feeds that are specific to OS distros (vulnerability data from RHEL, Debian, Ubuntu, Alpine, Oracle, etc).  If you wish to enable non-os vulnerability scanning (which adds support for scanning language packages (NPM, Gem, Java Archive, Python PIP), the 'nvd' feed must also be enabled.  In the below example, both the 'vulnerabilities' and 'nvd' feeds are enabled for automatic sync:

```YAML
feeds:
  sync_enabled: True
  selective_sync:
    enabled: True
    feeds:
      vulnerabilities: True 
      nvd: True
```

3. Postgres Database: the anchore engine requires access to a PostgreSQL database to operate. The database can be run as a container with a persistent volume or outside of your container environment (which is set up automatically if the example docker-compose.yaml is used). If you wish to use an external Postgres Database, the connection string of the PostgreSQL database can be specified in the config.yaml file. The default configuration points to host **anchore-db** on port **5432** using username **postgres** and password **mysecretpassword**.

If an external database service is being used then update the host, port, username and password. For an out-of-the-box installation using Docker Compose or manual installation the settings can be left unmodified.

`db_connect: 'postgresql+pg8000://postgres:mysecretpassword@anchore-db:5432/postgres'`


