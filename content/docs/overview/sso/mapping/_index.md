---
title: "Mapping SSO Identities into Anchore"
linkTitle: "Mapping SSO Identites into Anchore"
weight: 3
---

## Overview of Mapping External Identities into Anchore

Anchore SSO support provides a way to keep users' credentials centrally stored outside of an Anchore deployment in your 
central identity store but still use those identites for access to Anchore. Anchore's SSO approach uses the external identity 
store to authenticate an identity and bootstrap its initialization in Anchore's RBAC system. For each login, the user's
identity is verified against the external provider but once the identity is initialized inside the Anchore deployment, its
access to resources is controlled by the Anchore Enterprise RBAC system. This approach allows Anchore admins to manage user
access without having to require administrator access to a corporate or central IT identity system while still being able
to leverage that system for defining identity and securing access credentials.

The identity mapping process has two distinct phases:

1. Initial identity bootstrap - Occurs on the first login of a user to Anchore causing dynamic construction of an Anchore user record.
1. Identity verification and assertion validation - Validates the administrators requirements against the external identity record on each login.

## Defining the Username

By default, with SSO, the SAML Assertion's "Subject" attribute is used to define the username. Using the subject is the 
right solution in most situations, but in extreme cases it may be necessary to provide the username in some other form via
attributes in the SAML Response. This behavior can be configured by setting: `idp_username_attribute` in the IDP configuration 
record. This should only be used when the subject either cannot be used due to it being a transient ID as configured by the
IDP itself, or you want the username to map to some form other than the IDP's username, email, or persistent ID.

If the `idp_username_attribute` is set to an attribute name, and that attribute is not found or has no value in the SAML 
response presented during login, then that user login will be rejected by Anchore.

If `idp_username_attribute` is an empty string or null, then the SAML Response's subject attribute is used as the username.
This is the default behavior.

## Defining the Account the User Belongs To

In Anchore, all users belong to an Account. When an SSO user logs into Anchore UI for the first time, the identity is initialized
with the username (as defined above), but the account to which the user belongs is configurable via a separate pair of configuration
values in the IDP configuration of Anchore:

`default_account` - If set, this is used as the account for which all users that login from this IDP will be assigned.

* On first login - Creates the account as an `external` account if not already present in Anchore.
* On subsequent logins - No-op, but must be set in the IDP configuration.

`idp_account_attribute` - If set, this attribute overrides the `default_account` value and is the attribute name that will be
required to be set and valid in the SAML response for each user login.

* On first login - The attribute must exist and have at least one value. 
    * If not found or no value, login is rejected.
    * If found and has a value, the user is initialized with that account name as the owning account and roles are initialized in that account. The account is created if it does not exist.
    * Multi-value attributes are supported. See below for how that is handled.
* On subsequent logins - The attribute is checked and must have a valid value. If missing or empty, the login is rejected 
even if the user's identity has already been initialized.
* Handling multi-value attributes: If the attribute named in the configuration has multiple values, then multiple accounts 
are created and the specified roles (see below) are all applied to all accounts listed.
    * The owning account in this situation is defined by the `default_account` property value. If at login time the system 
    detects multiple account values and no default account set in the configuration, then login is rejected. This is true regardless of if the user is already initialized.
    * If the `idp_account_attribute` is set but has only one value, then the `default_account` value is ignored.
    * if the `idp_account_attribute` is set but the attribute is missing or empty, then login is rejected, even if `default_account` is set.
    
* Note: a login will be rejected if any of the accounts detected in the config or response are 'admin' or 'anchore-system'


## Defining the User's Initial Roles

`default_role` - Specify a single role set for all users that login with this IDP

* On first login - Specifies the role to be set on the account(s) during user identity initialization.
* On subsequent logins - Ignored if user already exists.

`idp_role_attribute` - Specifies the attribute name to use to lookup a list of roles to apply to the user's identity. Mutually 
exclusive with `default_role`. If both are set, the configuration will be rejected as invalid.

* On first login - Specifies the attribute to read. The user is granted this role on all accounts specified at initialization.
* On subsequent logins - If specified, the SAML response must have this attribute and it must have at least one value, otherwise login is rejected. 
This model allows the IDP admin to remove a user from accessing Anchore by removing or zeroing the the attribute set in this config for particular users or groups.

## Revoking SSO User Access

1. Disable the Anchore account. Any user, SSO or otherwise, that is a member of a disabled account cannot login or perform API operations.
1. Use `idp_role_attribute` and to revoke, simply remove or zero that attribute in the IDP and all affected users will no longer be able to login to Anchore.


## Changing the Anchore IDP Config

Initialization of identities and roles occurs on the user's first login. One initialized, if the configuration matches the
SAML response presented at login based on the rules covered above, then the user can login.

Thus, changes to the IDP configuration record in Anchore will affect subsequent log-ins and initializations of users. Using attributes
instead of defaults will impact the next logins as those attributes must be present for the user to login, but will not re-initialize the user.

## Examples

## Identity Mapping Example Configurations

Examples of configuration values for a single IDP configuration in Anchore to achieve different behavior:

1. All SSO users in one account with the same `read-write` permissions:
    * default_account = 'account'
    * default_role = 'read-write'

1. SSO users in accounts managed by the IDP property, for example a 'groups' property:
    * `default_account = null`
    * `default_role = null`
    * `idp_account_attribute = "primary_group"`
    * `idp_role_attribute = "roles"`    
    * Will initialize the user with the roles specified in the 'roles' attribute for the accounts in the 'primary_group' attribute.
        * E.g. if 'primary_group' = ['testers'], and 'roles' = ['read-only'] for a user, _testuser@mycompany.com_
        * _testuser@mycompany.com_ will be initialized at login as username = _testuser@mycompany.com_ in account _testers_ with role _read-only_
        * Because the account is from an attribute, _testuser2@mycompany.com_ might have 'primary_group' = ['security_engineers'] and 
        thus be initialized in a different account in Anchore.    

