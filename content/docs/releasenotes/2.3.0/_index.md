---
title: "Anchore Enterprise Release Notes - Version 2.3.0"
linkTitle: "2.3.0"
weight: 95
---

This release focuses on enabling the Microsoft ecosystem within Anchore to allow the same analysis flow and pipelines that you use for linux images to be applied to Windows images
as well for a consistent approach across ecosystems. It also includes several enhancements to the reporting and event management features of the UI.

### New Features

* Windows Container Image Support

  * Analyze and get vulnerabilities for Windows OS-based containers. Anchore ingresses Microsoft vulnerability data via the [MSRC](https://msrc.microsoft.com)
  * No requirement to run Anchore itself on windows or other changes to the infrastructure needed to deliver this feature

* NuGet/.NET Package Support (Tech Preview)

  * Detection and inclusion in analysis output as well as vulnerability scans

* GitHub Advisories vulnerability data

  * See [Configuring GitHub advisories]({{< ref "/docs/installation/feeds" >}}) for information on configuring the new feed including creating a GitHub token the driver can use for API calls to GitHub.

* Scheduled Reports

  * Create report templates for easy re-use of your most frequently used reports
  * Schedule reports for generation and get notifications when they are ready, delivered via Slack, email, webhooks, and the other supported notification integrations Enterprise provides.

* Event Management in the UI

  * Improved sorting, filtering, and deletion of events in the UI directly

* Improved RHEL/CentOS vulnerability matching using CVE-based feeds instead of RHSA-based data

  * To help provide early detection of vulnerabilities before a fix is available or for issues where a fix is not issued, Anchore now uses RedHat's CVE information instead of RHSA information
  * This also provides improved whitelist consistency between RHEL/Centos and images based on other distros since CVEs are consistent
  * For more details see [RHSA-to-CVE Feed Change]({{< ref "/docs/releasenotes/2.3.0/centos_to_rhel_upgrade" >}})

* Improved feed data and configuration management via APIs and CLI

  * New APIs and CLI commands allow dynamic configuration of which feeds to sync and the ability to enable/disable and delete feed data without updating configuration files or restarting containers.
  * See [CLI Feeds configuration]({{< ref "/docs/using/cli_usage/feeds/feed_configuration" >}})

* **Built on Anchore Engine v0.7.1:** Anchore Enterprise is built on top of the OSS Anchore Engine, which has received new features and updates in the 0.7 series. See [Anchore Engine Release Notes]({{< ref "/docs/engine/releasenotes" >}}) for information on new features, bug fixes, and improvements in Anchore Engine for versions v0.7.0 and v0.7.1.

### Changes

Starting in 2.3.0 all services except the UI in an Enterprise deployment must:

* Have the license.yaml available in /license.yaml inside the image. This is currently how the Notifiations, Reports, and RBAC services are run, and is now extended to all services.

* Be started with the `anchore-enterprise-manager` command instead of `anchore-manager`. This ensures that enterprise extensions and functionality is properly loaded and available.

* The docker-compose.yaml is no longer built into the image, but is available in the [quickstart]({{< ref "/docs/quickstart" >}}) via a link to download. The image versions will be set to the release version matching the documentation version.


These changes are all configured by default in the new [quickstart guide]({{< ref "/docs/quickstart" >}}) and are also enabled in the updated Helm chart for this release.

**As with previous releases, we recommend upgrading with the newest deployment templates rather than just changing the image references in existing templates.**

### Bug Fixes and Enhancements

* Fixed user deletion and role removal failures
* Uses NVD severity for Debian vulnerabilties when 'urgency' field not set in the upstream data
* Updates alpine feed driver to ensure severies are set using newer nvd2 driver data instead of older nvd driver that may have had stale data due to old NVD XML feed
* Adds new '--no-auto-upgrade' option to anchore-enterprise-manager to start services that will not upgrade the db automatically, enabling more control over the upgrade process
* Fixed Report CSV/JSON download missing records in UI
* Fixed scrollbar functionality issue in Policy Bundle editor in UI
* Fixed missing scrollbar for context switching in UI
* Fixed problem with sorting vulnerability columns in UI causing hangs and missing links
* Updates to dependencies
* Fixes in the Anchore Engine [v0.7.0 release notes]({{< ref "/docs/engine/releasenotes/0.7.0" >}}) and [v0.7.1 release notes]({{< ref "/docs/engine/releasenotes/071" >}})

### Upgrading from Anchore Enterprise 2.2 to 2.3.0

This is a significant upgrade. Backups should be taken, and downtime expected to complete the process.

**NOTE** The upgrade from 2.2.x to 2.3.0 will take several minutes at least for the database schema upgrade and involves a data migration can take longer to fully transition the RHSA data to CVE data. Part of this process is done during
the database upgrade, but part of the process can only complete after the upgraded feed service is able to run and sync the new RedHat CVE data. Because of this, there will be an interval where RHEL-based images
will have no vulnerabilities listed. That will automatically resolve itself once the feed syncs, and all affected images will have CVE-based vulnerability matches as expected, but depending on deployment environment and number
of images in the database, this may take a long time (hours potentially).

See [RHSA-to-CVE Feed Change]({{< ref "/docs/releasenotes/2.3.0/centos_to_rhel_upgrade" >}}) for more information on the change and upgrade implications. 

To upgrade, use the new version of the Helm chart or docker-compose provided with this release. The new chart and compose files contain all needed configuration changes. See [Enterprise Upgrade to 2.3.0]({{< ref "/docs/installation/upgrade" >}}) for details on this specific upgrade process and how to update your own deployment templates if you are not using the official Helm chart.

