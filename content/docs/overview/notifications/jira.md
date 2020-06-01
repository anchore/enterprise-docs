---
title: "Jira"
weight: 3
---

Notifications to Jira are in the form of new issues in a project

### Requirements

To receive notifications

1. The following Jira account and project related information is required
    * URL of the Jira project
    * Username of the account for creating issues
    * API token or password depending on the Jira project
        * For Jira Cloud projects an API token is required. [Follow instructions](https://confluence.atlassian.com/cloud/api-tokens-938839638.html) to create a new API token for the account creating issues
        * For Jira Self-managed projects password of the account creating issues is required
    * Project key, same as the prefix in the issue identifier. For instance, issue `TEST-1` has the project key `TEST`
    * Type of the issue created such as `Bug`, `Task`, `Story`, etc.
    * (Optional) priority assigned to the issue such as `Low`, `Medium`, `High`, etc.
    * (Optional) one or more labels to be assigned to the issue
    * (Optional) Jira user to be assigned to the issue
2. Create a Jira endpoint configuration in the Notifications service either via [Enterprise UI]({{< ref "/docs/using/ui_usage/notifications" >}}) or the API directly
