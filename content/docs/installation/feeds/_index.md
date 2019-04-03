---
title: "Feeds Configuration"
linkTitle: "Feeds"
weight: 6
---

## Introduction

In this section, you'll learn how what is required for configuring Anchore Engine to use the Anchore Enterprise Feeds.  

### Requirements

#### Network

- Ingress: Anchore Enterprise Feeds exposes a RESTful API by default on port 8228 however this port can be remapped.
- Egress: Anchore Enterprise Feeds requires access to the upstream data feeds from supported Linux distributions and package registries

| Host | Port | Description |
| :---- | :---- | :----------- |
| linux.oracle.com | 443 | Oracle Linux Security Feed |
| github.com | 443 | Alpine Linux Security Database |
| redhat.com | 443 | Red Hat Enterprise Linux Security Database |
| security-tracker.debain.org | 443 | Debian Security Feed |
| salsa.debian.org | 443 | Debian Security Feed |
| replicate.npmjs.com | 443 | NPM Registry Package Data |
| s3-us-west-2.amazonaws.com | 443 | Ruby Gems Data Feed |
| static.nvd.nist.gov | 443 | NVD Database |
| launchpad.net/ubuntu-cve-tracker | 443 | Ubuntu Data |
| data.anchore-enterprise.com | 443 | Snyk data |

#### Database

Ruby Gems project publishes package data as a PostgreSQL dump. Enabling the gem driver in Anchore Enterprise Feeds will increase the load on the PostgreSQL database used by the service. We recommend using a different PostgreSQL instance for the gem driver to avoid load spikes and interruptions to the service. The database endpoint for the gem driver can be configured using services->feeds->drivers->gem->db_connect parameter in config.yaml

### Configuration

To configure Anchore Engine to use Anchore Enterprise Feeds, complete the following steps:

1. Update the top level feeds property in Anchore Engine's config.yaml to use the Anchore Enterprise Feeds endpoint:

```YAML
feeds:
  selective_sync:
    enabled: True
    feeds:
      vulnerabilities: true
      packages: false
      nvd: false
      snyk: true
  url: 'http://enterprise-feeds:8228/v1/feeds'
```

In this example only operating system vulnerability data and vulnerability data from Snyk is synchronized, however the packages parameter can be set to true to configure Anchore Engine to synchronize NPM and GEM package data.

NOTE: The nvd parameter must be set to true to configure the Anchore Engine to download NVD vulnerability data, which used for matching vulnerabilities in non-operating system packages (NPM, GEM, Python, Java). While both the Snyk data feed also enables non-operating system package vulnerability scanning, without the NVD feed enabled, some non-os package vulnerabilities may not be reported.

2. Restart Anchore Engine (or just the Policy Engine component containers if you have split services out into their own containers) for the config changes to take effect. If the policy engine cannot reach the configured url it will raise an error and terminate during the bootstrap process. You can check the policy engine logs in /var/log/anchore/anchore-policy-engine.log for errors on the url configuration. If the service start successfully then it was able to reach the Anchore Enterprise Feeds endpoint.

You should now have and Anchore Engine executing feed syncs against the On-Premise Anchore Enterprise Feeds.