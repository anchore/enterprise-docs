---
title: "Accounts and Users"
weight: 1
---

### Overview

Anchore Engine provides simple access controls and isolation boundaries by providing accounts and users. Accounts are isolation boundaries for resources (images, registry credentials, policy bundles, etc), and users exist within an account and provide identities and authentication credentials for API access.  There are three kinds of accounts:

1. User Account - A standard account that can contain resources and zero or more user identities. Users in accounts of this type have full access to resources in their own account, but cannot manage other accounts or users.
2. Admin Account - A special account created at system initialization that has full privileges to manage accounts, users, system resources, and configuration as well as standard resources like images and policy bundles. The Admin account is initialized with an admin username and credential, but more users may be created in this account. The admin user in the admin account may not be deleted.
3. Service Account - Special system-internal accounts not visible to users or admins via the APIs, but used for internal operations and inter-service communications.

### Resource Isolation

Resources in Anchore Engine are fully isolated by account. An image analyzed in Account X is visible and shared by all users of account X, but a user in account Y cannot access that analysis and must analyze the image within the account Y namespace for it to be available.

If a group of users need to share a set of resources, they should all be in the same account. The admin account has the ability to access resources in other accounts but should be avoided as a mechanism for simple resource sharing since it has other access implications.

### Access Control

Access to all resources in Anchore Engine (0.3.0+) are gated by authorization checks which evaluate at user's permission set against a required authorization domain, action, and target. 

- Domain: defines the namespace for an action, in this case an Account, or system for global resources like accounts themselves
- Action: defined per API operation and can be found in the API swagger definition with the x-anchore-authz-action property on the path. For example, GET /images is mapped to the listImages action. 
- Target: the resource the action will operate on. Either a wild card, '*' for all, or a resource identifier (e.g. image digest).

Anchore Engine provides a simple static set of permissions for authorization:

- Users in the admin account:
    - Domain: *, Action: *, Target: * - These users can perform any action on any domain against any resource
    - Actions such as adding/deleting/updating users within an account require a domain of system, and the target is the account name, so these can only be done by admin account users
- Users in a User-type account:
    - Domain: the user's account, Action: *, Target: * - Can perform any action on any resource in that account domain but not other accounts or global resources
    - As mentioned above, user management operations require the system domain, so users in regular user accounts cannot manage accounts or users within their own account

#### Cross-Account Resource Access

To access resources in an account other than that to which a user belongs, a request should include the custom header: *x-anchore-account: <account to access>*. This has the effect of setting the account context for the request to that specified account. In the open source Anchore Engine, the only users that have permissions to access resources in other accounts are users in the admin account. 

### Account and User Life-cycle

Accounts have states, these states govern the operations that are permitted by users in the account. The states are:

1. Enabled - The starting state of a newly created account. The account is fully functional. This is the normal state for an account.
2. Disabled - Users of the account are locked out of the system and not permitted to perform any actions. Resources are unaffected, but asynchronous actions such as subscriptions and tag update watchers are disabled for accounts in this state. Essentially, the account is frozen.
3. Deleting - The account has been marked for deletion and its resources are being reaped by the system. Upon completion of deletion of all resources the account will be removed and the name can be re-used. To enter the Deleting state and account must first be in the Disabled state. This state is terminal.

For more information on managing users and accounts via the API or CLI, see: Managing Users and Accounts.