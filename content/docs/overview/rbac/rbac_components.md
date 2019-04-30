---
title: "RBAC Service Components"
weight: 1
---

RBAC in Anchore Enterprise is implemented as a pair of services: the RBAC Management API and the RBAC Authorizer.

### RBAC Manager

The manager is a user-facing component that proves a REST API for managing roles, role permissions, and role membership of users. It stores its state in the Anchore Enterprise schema of the Anchore Engine DB and is consumed by the Enteprise UI for the rbac-related management controls. See: Managing Accounts, Users, and Roles in the UI. Because this API is itself subject to RBAC controls, the manager invokes the RBAC Authorizer for authorization decisions on api calls.

As with other Anchore API services, it has the following utility routes in the API:

- */version* - Returns version information
- */health* - Returns 200 OK if service is running
- */ui/* - Opens a swagger-spec viewer UI to browse the API spec
- */swagger.json* - Obtain the API spec directly

For information on configuring and running the service, see: Quickstart or Configuring RBAC

### RBAC Authorizer

The RBAC Authorizer is an implementation of the anchore engine authorizer interface and is the component that is called directly by user-facing API services to provide authorization decisions. The Authorizer utilizes the same DB as the Manager and while its workload is predominantly read-only, there are a few write operations involved around managing the lifecycles of usernames and accounts as defined in the authorizer API (e.g. remove a user from all roles when the username is deleted). See: Anchore Engine Authorization Plugins

**NOTE: This is an internal component, it should never be exposed on the open network or have its ports exposed outside of the host. Typically, this means it is run with no host-port mappings and relies on Docker network/links to other local-host containers or runs within the same Kubernetes pod as the API components and also does not have a port on the pod IP.**