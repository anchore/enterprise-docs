---
title: "Anchore Enterprise Feeds Overview"
linkTitle: "Feeds"
weight: 4
---

Anchore Enterprise Feeds is an On-Premise service that supplies os and non-os vulnerability data and package data for consumption by Anchore Engine. Policy Engine, a service component of the Anchore Engine, uses this data for vulnerability listing and policy evaluation. For more information about Anchore Engine's usage of feeds, see feeds overview

Anchore maintains a public and free feed service at https://ancho.re/v1/service/feeds which is used by the open source Anchore Engine and Anchore Cloud. Anchore Enterprise Feeds offers the following benefits over the free service:

- Vulnerability data from 3rd party licensed feeds
- Run Anchore Enterprise in Air-Gapped mode
- Examine updates to vulnerability dataset (for audit trail) with advanced APIs
- Granular control and configuration over feed data due to On-Premise installation. Configure   how often the data from external sources is synced, enable/disable individual drivers         responsible for processing normalized data.

### Design Overview

![alt text](/EnterpriseFeeds.png)

Anchore Enterprise Feeds has three high level components - drivers, database and API

### Drivers

A driver downloads raw data from an external source and normalizes it. Each driver outputs normalized data for one of the four feed types - (os) vulnerabilities, packages, nvd or third party feeds

- Drivers responsible for operating system package vulnerabilities gather raw data from the respective os resources listed below
- Package drivers process the official list of packages maintained by NPM and RubyGems organizations 
- nvd driver processes all the CVEs in the NIST database and the supplies normalized data that can be used for matching non-os packages (such as Java, Python, NPM, GEM)
- third party drivers source vulnerability data for software artifacts, curated by the third party. Policy Engine may prioritize third-party data matches over other feed data sources, when availablem for matching vulnerabilities against software artifacts. 

All drivers except for the package drivers are enabled by default. The service has configuration toggles enabling/disabling each driver individually and tuning driver specific settings. 

| Driver | Feed Type | External Data Source |
| :------ | :----------- | :---------- |
| alpine | vulnerabilities | https://github.com/alpinelinux/alpine-secdb/archive/master.tar.gz |
| centos | vulnerabilities | https://www.redhat.com/security/data/oval/com.redhat.rhsa-all.xml.bz2 |
| debian | vulnerabilities | https://security-tracker.debian.org/tracker/data/json https://salsa.debian.org/security-tracker-team/security-tracker/raw/master/data/DSA/list |
| oracle | vulnerabilities | https://linux.oracle.com/security/oval/com.oracle.elsa-all.xml.bz2 |
| ubuntu | vulnerabilities | https://launchpad.net/ubuntu-cve-tracker |
| gem | packages | https://s3-us-west-2.amazonaws.com/rubygems-dumps |
| npm | packages | https://replicate.npmjs.com |
| nvd | nvd | https://nvd.nist.gov/vuln/data-feeds |
| <third-party> | <third-party> | https://data.anchore-enterprise.com |

### Database 

Normalized vulnerability and package data is persisted in the database. In addition, the execution state and updates to the data set are tracked in the database

### API

Anchore Enterprise Feeds exposes a RESTful API for interaction with the service. The API layer serves normalized data from the database based on the client requests. Policy Engine uses this API to sync the feed data down to the Anchore database.

