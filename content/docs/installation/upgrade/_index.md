---
title: "Upgrading Anchore Enterprise"
linkTitle: "Upgrade"
weight: 10
---

Upgrading from one version of Anchore Enterprise (UI, Enterprise Services, and Anchore Engine) is normally handled seamlessly by the Helm chart, and trial docker-compose configuration files that are provided along with each release, following the general methods from the guide below.

- [Upgrading Anchore Engine](/docs/engine/engine_installation/upgrade/)

This section is intended as a guide for any special instructions and information related to upgrading to specific versions of Enterprise.

### Upgrading from Anchore Enterprise 1.2 to Anchore Enterprise 2.0

Anchore Enterprise 2.0 includes all of the services of Enterprise 1.2, plus a new UI Dashboard control, UI LDAP Integration, and an additional element called the Reporting Service.  If you are using the anchore [Helm Chart installation method](/docs/installation/helm/), or upgrade by following the trial [Docker Compose](/docs/installation/docker_compose/) method, then there are no special considerations for the upgrade beyond setting (optionally) values for the new services.  

For Helm based deployments, information on install/upgrade is hosted alongside the official Anchore Helm Chart

- [Anchore Helm Chart](https://github.com/helm/charts/tree/master/stable/anchore-engine)

### Manual / Advanced Upgrade

The default upgrade path is fully automated if you have deployed with either Helm or docker-compose using the provided guides and methods described above and there are no additional or manual steps required.  If, however, you are manually deploying anchore services, there are a few new requirements that need to be met for the the 2.0 UI to start up.  

- The 2.0 UI now requires a postgres database endpoint be added to it's configuration file (appdb_uri), or environment variable override (ANCHORE_APPDB_URI).  
- There is an optional reporting service endpoint value that should be set (reports_uri) or environment override (ANCHORE_REPORTS_URI), without which the UI will be functional, but with a disabled Dashboard control.

See the following links for the latest configuration options available to the new Enterprise 2.0 components:

- [Anchore UI Configuration](/docs/installation/ui/ui_configuration/)
- [Reporting Service Configuration](/docs/overview/reports)

If you are manually deploying or using a method other than our provided installation tools, it is recommended that you inspect the latest Helm chart and/or the latest docker-compose.yaml to review the addition of the reporting service, reporting service configuration environment variables and section in the enterprise service config.yaml, and the addition of the new required configuration options to your existing UI config-ui.yaml configuration file.

