---
title: "Enabling Windows Scanning"
linkTitle: "Enabling Windows in Quickstart"
weight: 1
---

To enable windows support in the quickstart install docker-compose.yaml file you must:

1. Go to the directory where you have the quickstart docker-compose.yaml downloaded. Or, see [Quickstart]({{< ref "/docs/quickstart" >}}) for download and setup instructions.

1. If your system is already running, shut it down: `docker-compose down` (NOTE: do **NOT** use the `-v` option or that will delete your database and reset the systeme entirely)

1. Enable the feeds service to run. Uncomment the feeds service and enterprise-feeds-db services in docker-compose.yaml

    The following also includes the GitHub advisories feed for NuGet/.NET support and for parity with the hosted feed service.

    ```
    services:
      ...
      # Uncomment this section to add an on-prem feed service to this deployment. This will incur first-time feed sync delay, but is included for completeness / review of enterprise service deployment options
      enterprise-feeds-db:
        image: "postgres:9"
        volumes:
        - enterprise-feeds-db-volume:/var/lib/postgresql/data
        environment:
        - POSTGRES_PASSWORD=mysecretpassword
        expose:
        - 5432
        logging:
          driver: "json-file"
          options:
            max-size: 100m
      feeds:
        image: docker.io/anchore/enterprise:v2.3.0
        volumes:
        - feeds-workspace-volume:/workspace
        - ./license.yaml:/license.yaml:ro
        #- ./config-enterprise.yaml:/config/config.yaml:z
        depends_on:
        - enterprise-feeds-db
        ports:
        - "8448:8228"
        logging:
          driver: "json-file"
          options:
            max-size: 100m
        environment:
        - ANCHORE_ENDPOINT_HOSTNAME=feeds
        - ANCHORE_DB_HOST=enterprise-feeds-db
        - ANCHORE_DB_PASSWORD=mysecretpassword
        - ANCHORE_ENABLE_METRICS=false
        - ANCHORE_LOG_LEVEL=INFO
        # Uncomment the following to enable Microsoft msrc driver. Follow https://portal.msrc.microsoft.com/en-us/developer to generate an API key
        - ANCHORE_ENTERPRISE_FEEDS_MSRC_DRIVER_ENABLED=true
        - ANCHORE_ENTERPRISE_FEEDS_MSRC_DRIVER_API_KEY=<INSERT YOUR MSRC KEY HERE>
        # Uncomment ANCHORE_ENTERPRISE_FEEDS_GITHUB_DRIVER_TOKEN for github driver.
        # Generate token with https://github.com/settings/tokens/new?scopes=user,public_repo,repo,repo_deployment,repo:status,read:repo_hook,read:org,read:public_key,read:gpg_key
        # and assign the value to environment variable
        - ANCHORE_ENTERPRISE_FEEDS_GITHUB_DRIVER_TOKEN=<INSERT YOUR GITHUB KEY HERE>
        command: ["anchore-enterprise-manager", "service", "start",  "feeds"]

    ```

1. Configure the policy engine to use the deployed feed service instead of the hosted feed service

    Ensure the following environment variables are set in the docker-compose.yaml file:

    ```
    services:
      ...
      policy-engine:
        ...
        environment:
          ...
          # Uncomment the ANCHORE_FEEDS_* environment variables (and uncomment the feeds db and service sections at the end of this file) to use the on-prem feed service
          - ANCHORE_FEEDS_URL=http://feeds:8228/v1/feeds
          - ANCHORE_FEEDS_CLIENT_URL=null
          - ANCHORE_FEEDS_TOKEN_URL=null
      ...
    ```

1. Start/Restart the deployment: `docker-compose up -d`

1. Wait for vulnerability data to sync:
`docker-compose exec api anchore-cli system feeds list` should show 'msrc' group data syncing as rows are populated.
Verify with `anchore-cli event list` should show a feed sync complete event for the 'microsoft' feed.

1. Scan windows images! Either via the UI, or CLI analyze windows-based images

1. Installed KBs available via the 'OS' content type: `anchore-cli image content <windows img> os`
