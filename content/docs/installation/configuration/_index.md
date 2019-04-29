---
title: "Configuring Anchore"
linkTitle: "Configuration"
weight: 9
---

## Introduction

A single configuration file config.yaml is required to run the Anchore Engine - this file is typically passed to the Anchore Engine in a volume.  A default [config.yaml](https://raw.githubusercontent.com/anchore/anchore-engine/master/scripts/docker-compose/config.yaml) is provided as a way to get started, which is functional when combined with the default [docker-compose.yaml](https://raw.githubusercontent.com/anchore/anchore-engine/master/scripts/docker-compose/docker-compose.yaml), but many options are disabled by default and can be tuned to your liking. See [Anchore Engine Configuration](/docs/engine/engine_installation/configuration/config) for more details.

Jump to the following configuration guide below:

- [Network Proxies](/docs/engine/engine_installation/configuration/network_proxies)
- [Custom Certificates](/docs/engine/engine_installation/configuration/custom_certs)
- [TLS / SSL](/docs/engine/engine_installation/configuration/tls_ssl_config)