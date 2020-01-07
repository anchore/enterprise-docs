---
title: "GitHub"
weight: 2
---

Notifications to GitHub are in the form of new issues in a repository

### Requirements

To receive notifications

1. The following GitHub account and repository related information is required
    * Username of the account for creating issues
    * Token with repository access. [Follow instructions](https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line#creating-a-token) to create a new Access Token in the account used for creating issues
    * Name of the repository where the issues are created
    * Owner of the repository
    * (Optional) GitHub API URL, defaults to https://api.github.com if not specified
    * (Optional) milestone assigned to the issue
    * (Optional) one or more labels assigned to the issue
    * (Optional) one or more GitHub users assigned to the issue
2. Create a GitHub endpoint configuration in the Notifications service either via [Enterprise UI]({{< ref "/docs/using/ui_usage/notifications" >}}) or the API directly
