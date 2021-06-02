---
title: "Anchore CLI"
linkTitle: "Anchore CLI"
weight: 3
---

### Introduction

In this section you will learn how to install and configure AnchoreCTL, the Anchore Enterprise CLI.
The AnchoreCTL Enterprise CLI provides a command line interface on top of the Anchore Enterprise & Engine REST APIs. 
AnchoreCTL is published as a Cobra-CLI Go Binary that can be installed from a public S3 bucket. 
Using AnchoreCTL, users can manage and inspect images, manage their false-positive management settings, manage their runtime inventory settings, interact with the runtime compliance API, and even generate/upload image SBOMs.

### Getting Started
Installation of AnchoreCTL (from a release) happens a few different ways, depending on your preference

#### macOS
```shell script
curl -o anchorectl.dmg https://anchorectl-releases.s3-us-west-2.amazonaws.com/v0.1.0/anchorectl_0.1.0_darwin_amd64.dmg
```
```shell script
aws s3 cp s3://anchorectl-releases/v0.1.0/anchorectl_0.1.0_darwin_amd64.dmg anchorectl.dmg
```

#### Debian

```shell script
curl -o anchorectl.deb https://anchorectl-releases.s3-us-west-2.amazonaws.com/v0.1.0/anchorectl_0.1.0_linux_amd64.deb
```
```shell script
aws s3 cp s3://anchorectl-releases/v0.1.0/anchorectl_0.1.0_linux_amd64.deb anchorectl.deb
```

#### RPM

```shell script
curl -o anchorectl.rpm https://anchorectl-releases.s3-us-west-2.amazonaws.com/v0.1.0/anchorectl_0.1.0_linux_amd64.rpm
```
```shell script
aws s3 cp s3://anchorectl-releases/v0.1.0/anchorectl_0.1.0_linux_amd64.rpm anchorectl.rpm
```

#### Linux Tar

```shell script
curl -o anchorectl.tar.gz https://anchorectl-releases.s3-us-west-2.amazonaws.com/v0.1.0/anchorectl_0.1.0_linux_amd64.tar.gz
```
```shell script
aws s3 cp s3://anchorectl-releases/v0.1.0/anchorectl_0.1.0_linux_amd64.tar.gz anchorectl.tar.gz
```

#### Windows

```shell script
curl -o anchorectl.zip https://anchorectl-releases.s3-us-west-2.amazonaws.com/v0.1.0/anchorectl_0.1.0_windows_amd64.zip
```
```shell script
aws s3 cp s3://anchorectl-releases/v0.1.0/anchorectl_0.1.0_windows_amd64.zip anchorectl.zip
```


### Config
AnchoreCTL can be configured via a config file at the following locations, with the following precedence:
1. Environment Vars (i.e. ANCHORECTL_ANCHORE_USER)
2. Config Path override (note: if this file is not found, config SHOULD fail)
3. .anchorectl.yaml or anchorectl.yaml
4. .anchorectl/config.yaml
5. ~/.anchorectl.yaml
6. ~/anchorectl/config.yaml

To get a release-matched version of this configuration file, you can retrieve it as follows:
```shell script
curl -o anchorectl.yaml https://anchorectl-releases.s3-us-west-2.amazonaws.com/v0.1.0/anchorectl.yaml
```
```shell script
aws s3 cp s3://anchorectl-releases/v0.1.0/anchorectl.yaml anchorectl.yaml
```
Note that it has detailed comments above each configuration value so you know what each does.

#### Required
At the very least, AnchoreCTL needs the following information
* Anchore Connection details (including authentication information)
* `enterpriseEnabled: true`. This is the default value, but it _must_ be specified in order for the enterprise-related features to work. 
