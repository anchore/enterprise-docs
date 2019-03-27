---
title: "Migrating Data Between On-Premise Anchore Enterprise Feeds Installations"
weight: 1
---

The On-Premise Anchore Enterprise Feeds has two high level functions:

- Gather vulnerability data from external sources, normalize and persist the data
- Serve persisted normalized vulnerability data from via an API

These two high level functions are decoupled and can be executed independently of each other. This design allows the service to operate in a Read-Only mode and service API requests with the vulnerability data in the service's database. It is used for running Anchore Enterprise in Air-Gapped mode

**Warning:** The following process deletes the database of the Read-Only installation. Ensure the database is not used by other services such as Anchore Engine

Start with the public network

1. Install Anchore Enterprise Feeds in a public network with access to internet, see network requirements
2. Start the service and use the tasks API to query the status of the FeedSyncTask that should have started
3. Wait for the FeedSyncTask to complete and populate the database
4. Stop the service
5. Create a database dump using pg_dump tool
`pg_dump -h <public-network-db-hostname> -p 5432 -U postgres -Fc -v -f anchore-enterprise-feeds.dump postgres`
6. Copy it to a location where it can be restored from in the following steps

Next, switch to the private network where Anchore Engine is installed

1. Install Anchore Enterprise Feeds in the private network alongside Anchore Engine, don't start the service. 

2. Configure Read-Only mode by setting api_only: True property in the config.yaml 

```YAML
feeds:
  ...
  api_only: True
  ...
```

3. Restore the database from the anchore-enterprise-feeds.dump file created in the previous section

`pg_restore -h <private-network-db-hostname> -p 5432 -U postgres -C -d postgres anchore-enterprise-feeds.dump`

4. Start the service

**Note:** PostgreSQL version must be the same across both databases for the pg_dump and pg_restore utility to work correctly