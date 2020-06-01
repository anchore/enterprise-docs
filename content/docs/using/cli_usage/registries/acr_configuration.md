---
title: "Working with Azure Registry Credentials"
weight: 1
---

To use an Azure Registry, you can configure Anchore to use either the admin credential(s) or a service principal. Refer to Azure documentation for differences and how to setup each.  When you've chosen a credential type, use the following to determine which registry command options correspond to each value for your credential type

- Admin Account

    - Registry: The login server (Ex. myregistry1.azurecr.io)
    - Username: The username in the 'az acr credential show --name <registry name>' output
    - Password: The password or password2 value from the 'az acr credential show' command result

- Service Principal

    - Registry: The login server (Ex. myregistry1.azurecr.io)
    - Username: The service principal app id
    - Password: The service principal password  
      Note: You can follow [Microsoft Documentation](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-auth-service-principal) for creating a Service Principal.

To add an azure registry credential, invoke `anchore-cli` as follows:

`anchore-cli registry add --registry-type <Registry> <Username> <Password>`

Once a registry has been added, any image that is added (e.g. `anchore-cli image add <Registry>/some/repo:sometag`) will use the provided credential to download/inspect and analyze the image.
