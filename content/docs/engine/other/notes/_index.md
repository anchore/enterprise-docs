---
title: "Data Privacy"
linkTitle: "Data Privacy"
weight: 3
---

The Anchore Engine is designed to run locally and does not share any data with Anchore Inc. or any third party.

The Anchore Engine will download data from Anchore's cloud service anchore.io however no data is uploaded to Anchore.

Depending on your configuration the following data will be downloaded from Anchore's cloud.

- CVE Vulnerability data (Alpine, CentOS, Debian, Oracle, RHEL, Ubuntu) - sourced from Vendor CVE databases
- NPM package data from the NPM Package Database
- Ruby Gems package data from the Ruby Gems repository
- Any user define policies and whitelists created on Anchore's cloud service.