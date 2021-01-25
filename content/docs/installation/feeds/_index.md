---
title: "Feeds"
linkTitle: "Feeds"
weight: 6
---

## Introduction

In this section, you'll learn about the requirements for installing Anchore Enterprise Feeds and configuring its components. The section also contains instructions for configuring Anchore Engine installation to use Anchore Enterprise Feeds. You can read more about Anchore Enterprise Feeds [here]({{< ref "/docs/overview/feeds" >}})

### Requirements

#### Network

- Ingress: Anchore Enterprise Feeds exposes a RESTful API by default on port 8228 however this port can be remapped.
- Egress: Anchore Enterprise Feeds requires access to the upstream data feeds from supported Linux distributions and package registries

| Host | Port | Description |
| :---- | :---- | :----------- |
| linux.oracle.com | 443 | Oracle Linux Security Feed |
| github.com | 443 | Alpine Linux Security Database |
| redhat.com | 443 | Red Hat Enterprise Linux Security Database |
| access.redhat.com | 443 | Red Hat Security Data API |
| security-tracker.debian.org | 443 | Debian Security Feed |
| salsa.debian.org | 443 | Debian Security Feed |
| replicate.npmjs.com | 443 | NPM Registry Package Data |
| s3-us-west-2.amazonaws.com | 443 | Ruby Gems Data Feed |
| nvd.nist.gov | 443 | NVD Database |
| git.launchpad.net | 443 | Ubuntu Data |
| alas.aws.amazon.com | 443 | Amazon Linux ALAS Data Feed |
| api.msrc.microsoft.com | 443 | Microsoft Security Update API |
| data.anchore-enterprise.com | 443 | Third Party Data Feeds|


#### Database

Ruby Gems project publishes package data as a PostgreSQL dump. Enabling the gem driver in Anchore Enterprise Feeds will increase the load on the PostgreSQL database used by the service. We recommend using a different PostgreSQL instance for the gem driver to avoid load spikes and interruptions to the service. The database endpoint for the gem driver can be configured using services->feeds->drivers->gem->db_connect parameter in config.yaml

### Driver Configuration

Some of the feed drivers will require additional configuration steps, like retrieving an API or token key from a provider.

#### Github Driver

The Github driver requires to generate a Personal Access Token (PAT) which is associated with a Github Account. To generate this token, the user will be required to log in to Github and use the following url: [https://github.com/settings/tokens/new](https://github.com/settings/tokens/new?scopes=user,public_repo,repo,repo_deployment,repo:status,read:repo_hook,read:org,read:public_key,read:gpg_key)

The token requires full access to the `repo` and `user` scopes. Additionally, it requires read permissions in `admin:org`, `admin:public_key`, `admin:repo_hook`, and `admin:gpg_key` scopes. A note may be added as a reminder for what the token is being used. At the bottom of the tokens page, click the *Generate token* button which will show a new page displaying the generated token. Make sure you copy that token and use it to configure the Github driver, the token will only be seen once in the Github interface.

Use the new token in _config.yaml_ in the `feeds` section: for all components of the deployment:

```YAML
  feeds:
      ...
      github:
        enabled: true
        token: "****************************************"
```

It is also possible to set the token with the following environment variable: `ANCHORE_ENTERPRISE_FEEDS_GITHUB_DRIVER_TOKEN`. Note that this is only valid when using the _config.yaml_ provided in the image due to that file referencing them explicitly as replacement values.

#### MSRC Driver

MSRC driver requires access to Microsoft Security Update API for raw source data. Access to this API is gated by an API key. To request an API key head over to https://portal.msrc.microsoft.com/en-us/developer and create an account. 

NOTE: The service may currently require @outlook.com, @live.com or @microsoft.com email address for generating an API key. If you do not have one of these email addresses, you can create a personal outlook account to access this service       

Once an API key is available, the feed driver must be enabled and configured to use it 

- For quickstart and deployments using docker-compose.yaml: Find the `feeds` service definition and uncomment or add the following environment variables

    ```YAML
    services:
      ...  
      feeds:
      ...
        environment:
        ...
        - ANCHORE_ENTERPRISE_FEEDS_MSRC_DRIVER_ENABLED=true
        - ANCHORE_ENTERPRISE_FEEDS_MSRC_DRIVER_API_KEY=<api-key>
    ```

- For deployments using config.yaml: Find the `feeds` configuration section and update the f
 
    ```YAML
    services:
      ...  
      feeds:
      ...
        drivers:
          msrc:
            enabled: true
            api_key: <api-key>
    ```

### Configuring Anchore Engine to use Anchore Enterprise Feeds

To configure Anchore Engine to use Anchore Enterprise Feeds, complete the following steps:

1. Update the top level feeds property in Anchore Engine's config.yaml to use the Anchore Enterprise Feeds endpoint:

```YAML
feeds:
  selective_sync:
    enabled: True
    feeds:
      vulnerabilities: true
      packages: false
      nvdv2: false
  url: 'http://enterprise-feeds:8228/v1/feeds'
```

In this example only operating system vulnerability data is synchronized, however the packages and NVD (for non-os package vulnerability matches) parameter can be set to true to configure Anchore Engine to synchronize NPM and GEM package data.

NOTE: The nvd parameter must be set to true to configure the Anchore Engine to download NVD vulnerability data, which used for matching vulnerabilities in non-operating system packages (NPM, GEM, Python, Java, NuGet).

2. Restart Anchore Engine (or just the Policy Engine component containers if you have split services out into their own containers) for the config changes to take effect. If the policy engine cannot reach the configured url it will raise an error and terminate during the bootstrap process. You can check the policy engine logs in /var/log/anchore/anchore-policy-engine.log for errors on the url configuration. If the service start successfully then it was able to reach the Anchore Enterprise Feeds endpoint.

You should now have and Anchore Engine executing feed syncs against the On-Premises Anchore Enterprise Feeds.


