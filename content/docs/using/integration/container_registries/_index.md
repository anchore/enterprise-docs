---
title: "Registry Integrations"
linkTitle: "Registry Integrations"
weight: 6
---

## Image Registry Integrations

It makes sense in many cases to integrate a container scanner directly into the container registry so that results are visible directly
to the image consumers that may or may not have access to Anchore directly.

Anchore is able to scan images from nearly all image registries, but here we curate a list of registries for which there is
a direct integration with Anchore such that the registry can either directly initiate scans on Anchore and/or present those results
directly to its users.

- [Harbor Project](https://goharbor.io) and the [Harbor Scanner Adapter for Anchore](https://github.com/anchore/harbor-scanner-adapter)