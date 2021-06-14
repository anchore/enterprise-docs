---
title: "Anchore Enterprise Feeds"
linkTitle: "Feeds"
weight: 4
---

### Overview

Anchore Enterprise Feeds is an On-Premises service that supplies os and non-os vulnerability data and package data for consumption by Anchore Engine. Policy Engine, a service component of Anchore Engine, uses this data for finding vulnerabilities and evaluating policies. Read more about how Anchore Engine manages feed data [here]({{< ref "/docs/using/cli_usage/feeds" >}}) 

Anchore maintains a public and free feed service at https://ancho.re/v1/service/feeds which is used by open source Anchore Engine. Anchore Enterprise Feeds offers the following benefits over the free service:

- Vulnerability data from 3rd party licensed feeds
- Run Anchore Enterprise in Air-Gapped mode
- Examine updates to vulnerability dataset (for audit trail) with advanced APIs
- Granular control and configuration over feed data due to On-Premises installation. Configure how often the data from external sources is synced, enable/disable individual drivers responsible for processing normalized data.

### Design


Anchore Enterprise Feeds has three high level components:

* Drivers -- Communicate with upstream sources and fetch data and normalize it for anchore.
* Database -- Stores the current state of the normalized data for serving via api
* API -- Serves the data to clients, supporting update-only fetches.

### Grype
Anchore Enterprise 3.1 includes a limited-functionality tech preview of an integration with [Grype](https://github.com/anchore/grype) for vulnerability
scanning. This integration will replace the legacy vulnerability scanner in a future version of Anchore Engine, but is provided here in a preview capacity
so users can try it out.

***Note:*** This tech preview is not intended for use in production environments. It should be installed in sandbox environments, and is strictly provided
here so users can get start to use it and get a sense for the functionality. It may not include all the functionality of the legacy scanner. Please report
any issues found with it on the anchore-engine Github repo (include link).


#### Drivers

A driver downloads raw data from an external source and normalizes it. Each driver outputs normalized data for one of the four feed types - (os) vulnerabilities, packages, nvd or third party feeds

- Drivers responsible for operating system package vulnerabilities gather raw data from the respective os resources listed below
- Package drivers process the official list of packages maintained by NPM and RubyGems organizations 
- nvdv2 driver processes CVEs from the NIST database and the supplies normalized data that is used for matching non-os packages (such as Java, Python, NPM, GEM, NuGet)
- third party drivers source vulnerability data for software artifacts, curated by the third party. Policy Engine may prioritize third-party data matches over other feed data sources, when available for matching vulnerabilities against software artifacts. 

All drivers except for the package drivers are enabled by default. The service has configuration toggles enabling/disabling each driver individually and tuning driver specific settings.

| Driver | Feed Type | External Data Source |
| :------ | :----------- | :---------- |
| alpine | vulnerabilities | https://github.com/alpinelinux/alpine-secdb/archive/master.tar.gz |
| rhel | vulnerabilities | https://access.redhat.com/hydra/rest/securitydata/cve.json |
| centos (deprecated) | vulnerabilities | https://www.redhat.com/security/data/oval/com.redhat.rhsa-all.xml.bz2 |
| debian | vulnerabilities | https://security-tracker.debian.org/tracker/data/json https://salsa.debian.org/security-tracker-team/security-tracker/raw/master/data/DSA/list |
| oracle | vulnerabilities | https://linux.oracle.com/security/oval/com.oracle.elsa-all.xml.bz2 |
| ubuntu | vulnerabilities | https://launchpad.net/ubuntu-cve-tracker |
| amzn | vulnerabilities | https://alas.aws.amazon.com/AL2/ |
| gem | packages | https://s3-us-west-2.amazonaws.com/rubygems-dumps |
| npm | packages | https://replicate.npmjs.com |
| github | github | https://github.com |
| nvd (deprecated) | nvd (deprecated) | https://nvd.nist.gov/vuln/data-feeds |
| nvdv2 | nvdv2 | https://nvd.nist.gov/feeds/json/cve/1.1/ |
| msrc | microsoft | https://api.msrc.microsoft.com/ |
| third-party | third-party | https://data.anchore-enterprise.com |


#### Database

Normalized vulnerability and package data is persisted in the database. In addition, the execution state and updates to the data set are tracked in the database

#### API

Anchore Enterprise Feeds exposes a RESTful API. It accepts client requests and serves normalized data accordingly. Policy Engine is one of the clients using this API to sync the feed data. [Click here]({{< ref "/docs/using/api_usage/feeds" >}}) to read more about API access


### Configuration

[Click here]({{< ref "/docs/installation/feeds" >}}) to read about installation requirements for an air-gapped deployment and optional configuraiton of drivers    