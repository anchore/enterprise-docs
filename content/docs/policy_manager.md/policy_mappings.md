---
title: "Policy Mappings"
weight: 1
---

![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36006095671/original/ZfZPL8AqrMLupTJQBSXqhLUrzyItGOxfFw?1525634234)

The Policy Mapping editor creates rules that define which policies and whitelists should be used to perform the policy evaluation of an image based on the registry, repository name and tag of the image.
Using the policy editor organizations can set up multiple different policies that will be used on different images based on use case.
For example the policy applied to a web facing service may have different security and operational best practices rules than a database backend service.

Mappings are setup based on the Registry, Repository and Tag of an image.
Each field supports wildcards.

For example:

| Registry | Repository | Tag |
| ----- | ------ | ------ |
| registry.example.com | Apply mapping to the registry.example.com |
| anchore/web* | Map any repository starting with web* in the anchore namespace |
| Tag | * | All tags |

In this example an imaged named **registry.example.com/anchore/webapi:latest** would match this mapping and so the policy and whitelist configured for this mapping would be applied.

The mappings are applied in order, from top to bottom and the system will stop at the first match.

Note: The trusted images and blacklisted images lists take precedence over the mapping. See this document for details.

The empty policy bundle includes no mappings. Press the ![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36006095731/original/KLaVoBwQQmWyuN9hN5M91RtjdLOFtKqhWA?1525634660) to add your first mapping.

![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36005886274/original/qlNTueNq0RUQ2prmyb5hrwMIg2ihK9XkOQ.png?1525313979)

The *Add a New Mapping* dialog will be displayed and includes mandatory fields for *name, policy, registry, repository and tag*. The Whitelist(s) field is optional.

![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36005886279/original/RctFYRsHGqwBNuwKwA6DDB8XLkHmF0Ux4A.png?1525314000)

| Field Name | Description |
| ---------- | ----------- |
| Name | A unique name to describe the mapping. eg. "Mapping for webapps" |
| Policy | Name of policy to use for evaluation. A drop down will be displayed allowing selection of a single policy |
| Whitelist | Optional: The whitelist(s) to be applied to the image evaluation. Multiple whitelists may be applied to the same image. |
| Registry | The name of the registry to match. Note the name should exactly match the name used to submit the image or repo for analysis eg. foo.example.com:5000 is different to foo.example.com Wildcards are supported. A single * would specify any registry. |
| Repository | The name of the repository, optionally including namespace eg. webapp/foo Wildcards are supported. A single * would specify any repository. Partial names with wildcards are supported. eg. web*/* |
| Tag | Tags mapped by this rule. eg. latest Wildcard are supported. A single * would match any tag. Partial names with wildcards are supported. eg 2018* |

Each entry field includes an indicator showing if the current entry is valid ![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36005886290/original/6cFyOOYqhfFtSJG0Y1G2Rtgmna6Byc7nyA.png?1525314022) or has errors ![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36005886293/original/HxJAt17TvDeL9gxd-IngLOHJtQ2oFtG61A.png?1525314032).

In the screenshot below you can see multiple policy mappings have been defined some of which include one or more whitelists.

**Note:** As of Anchore Engine 0.2.1 only a single policy can be mapped to an image, however a later version of the engine will support mapping multiple policies to an image. This will simplify policy creation allowing smaller 'building blocks' to be assembled together to form a final set of policies rather than require duplication of checks between policies.

![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36005886289/original/yKzVYjHwL7Q9wlCmCANnHasxtqqfCulKdg.png?1525314017)

Image evaluation is performed sequentially from top to bottom. The system will stop at the first match so particular care should be paid to the ordering.

Mappings can be reordered using the ![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36005886299/original/SLBmiVzTJs_2fZKmLQYAlmzSCmT8xQ5h1A.png?1525314053) buttons which will move a mapping up or down the list. Mappings may be deleted using the ![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36005886297/original/SstIV1FjuVei0d3SYG4ZuyR1RGMqBv6Tcw.png?1525314045) button.

Anchore recommends that a final catch all mapping is applied to ensure that all images are mapped to a policy. This catch-all mapping should specify wildcards in the registry, repository and tag field.







