---
title: "Role-Based Access Control"
linkTitle: "RBAC"
weight: 4
---

### Overview

Added in Anchore Enterprise v1.2

Anchore Enterprise includes support for using Role-Based Access Control (RBAC) to control the permissions that a specific user has to a specific set of resources in the system. This allows administrators to configure specific, limited, permissions on user enabling limited access usage for things like CI/CD automation accounts, read-only users for browsing analysis output, or security team users that can modify policy but not change image analysis configuration.

Anchore Enterprise provides a predefined and immutable set of roles:

1. Full Control - All permissions on resources in the account
2. Read Write- Standard user permissions
3. Read Only - Read but no updates on all resources
4. Policy Editor - Create/Update/Delete policies and view policy evaluations on images 
5. Account Users Admin - Add/delete/update users in the account
6. Image Analyzer - Analyze, view, and evaluate policy on images

The Enterprise UI contains an enumeration of the specific permissions granted to users that are members of each of the roles.

### Roles, Users, and Accounts

Roles are applied within the existing account and user frameworks defined in Anchore Engine. Resources are still scoped to the account namespace and accounts provide full resource isolation (e.g. an image must be analyzed within an account to be referenced in that account). Roles allow users to be granted permissions in both the account to which they belong as well as external accounts to facilitate resource-sharing.

#### Terminology

**User:** An authenticated identity (a principal in rbac-speak) (unchanged from the Anchore Engine usage)

**Account:** A resource namespace and user grouping that also defines an authorization domain to which permissions are applied (unchanged from Anchore Engine usage)

**Role:** A named set of permissions

**Permission:** An action, target tuple to grant an operation on a set of resources

**Action:** The operation to be executed (e.g. listImages, createRegistry, updateUser)

**Target:** The resource to be operated on (e.g. an image digest). In Anchore Enterprise 1.2, the target of all permissions is '*' (all). Resource instance-level permissions are not yet supported.

**Role Membership:** Mapping a username to a role within a specific account, this has the effect of conferring the permissions defined by the role to resources in the specified account to the specified user. The user is not required to be a member of the account itself.

#### Constraints

1. A user may be a member of a role within one or more accounts
2. A user may be a member of many roles, or no roles
3. There is no default role set on a user when a user is created. Membership must be explicitly set.
4. Roles are immutable, the set of actions they grant is static
5. Creating and deleting accounts is only available to users in the admin account, the scope of accounts and roles is different than other resources because they are global. The authorization domain for those resources is not the account name but rather the global domain: system.

### Role Summary and Permissions

| Role | Allowed Actions | Description |
| :--- | :-------------- | :---------- |
| Full Control | * | Full control over any account granted for. USE WITH EXTREME CAUTION |
| Account User Admin | listUsers
createUser
updateUser
deleteUser
listRoles
getRole
listRoleMembers
createRoleMember
deleteRoleMember | Manage account creation and addition of users to accounts |
| Read Write | createImage
createPolicy
createRegistry
createRepository
createSubscription
deleteEvents
deleteImage
deletePolicy
deleteRegistry
deleteSubscription
getAccount
getEvent
getImage
getImageEvaluation
getPolicy
getRegistry
getService
getSubscription
importImage
listEvents
listFeeds
listImages
listPolicies
listRegistries
listServices
listSubscriptions
updateFeeds
updatePolicy
updateRegistry
updateSubscription | Full read-write permissions for regular account-level resources, excluding user/role management |
| Read Only | listImages
getImage
listPolicies
getPolicy
listSubscriptions
getSubscription
listRegistries
getRegistry
getImageEvaluation
listFeeds
listServices
getService
listEvents
getEvent | Read only access to account resources, but includes policy evaluation permission |
| Policy Editor | listImages
listSubscriptions
listPolicies
getImage
getPolicy
getImageEvaluation
createPolicy
updatePolicy
deletePolicy | Edit policies, get evaluations of images, intended for users to set policies but not change the scanning configurations |
| Image Analyzer | listImages
getImage
createImage
getImageEvaluation
listEvents
getEvent
listSubscriptions
getSubscription |
| Submit images for analysis, get results, but not change config. Intended for CI/CD systems and automation |

### Granting Cross-Account Access

The Anchore API supports a specific mechanism for allowing a user to make requests in another account's namespace, the x-anchore-account header. By including x-anchore-account: <desiredaccount>, on a request, a user can attempt that request in the namespace of the other account. This is, of course, subject to full authorization and RBAC.

To grant a username the ability to execute operations in another account, simply make the username a member of a role in the desired account This can be accomplished in the UI or via API against the RBAC Manager service endpoint. For example, using curl:

`curl -u admin:foobar -X POST -H "Content-Type: application/json" -d '{"username": "someuser", "for_account": "some_other_account"}' http://localhost:8229/roles/policy-editor/members`

This should be done with caution as there is currently no support for resource-specific access controls, a user will have the permitted actions on all resources in the other account (based on the permissions of the role). For example, making a user a member of policy-editor role for another account will enable full ability to create, delete, and update that account's policy bundles.

**WARNING: Because roles to not currently provide custom target/resource definitions, assigning users to the Account User Admin role for an account other than their own is dangerous because there are no guards against that user then removing permissions of the granting user (unless that user is an 'admin' account user), so use with extreme caution.**

**NOTE: admin account users are not subject to rbac constraints and therefore always have full access to add/remove users to roles in any account. So, while it is possible to grant them role membership, the result is a no-op and does not change the permissions of the user in any way.**