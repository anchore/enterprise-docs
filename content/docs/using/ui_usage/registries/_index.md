---
title: "Configuring Registries"
linkTitle: "Registries"
weight: 2
---

## Introduction

In this section you will learn how to configure access to registies within the Anchore Enterprise UI.

### Assumptions

- You have a running instance of Anchore Enterprise and access to the UI.
- You have the appropriate permissions to list and create registries. This means you are either a user in the admin account, or a user that is already a member of the read-write role for your account.

The UI will attempt to download images from any registry without requiring further configuration. However, if your registry requires authentication then the registry and corresponding credentials will need to be defined.

First off, after a successful login, navigate to the Configuration tab in the main menu.

![alt text](UIMenuConfigTab.png)

### Add a New Registry

In order to define a registry and its credentials, navigate to the **Registries** tab within Configuration. If you have not yet defined any registries, select the **Let’s add one!** button. Otherwise, select the Add New **Registry** button on the right-hand side.

Upon selection, a modal will appear:

![alt text](UIAddNewRegistry.png)

A few items will be required:

- Registry
- Type (e.g. docker_v2 or awsecr)
- Username
- Password

As the required field values may vary depending on the type of registry and credential options, they will be covered in more depth below. A couple additional options are also provided:

- Allow Self Signed
  By default, the UI will only pull images from a TLS/SSL enabled registry. If the registry is protected with a self signed certificate or a certificate signed by an unknown certificate authority, you can enable this option by sliding the toggle to the right to instruct the UI not to validate the certificate.

- Validate on Add
  Credential validation is attempted by default upon registry addition although there may be cases where a credential can be valid but the validation routine can fail (in particular, credential validation methods are changing for public registries over time). Disabling this option by sliding the toggle to the left will instruct the UI to bypass the validation process.

Once a registry has been successfully configured, its credentials as well as the options mentioned above can be updated by clicking Edit under the Actions column. For more information on analyzing images with your newly defined registry, refer to: UI - Analyzing Images.

![alt text](UIRegistriesTab.png)

The instructions provided below for setting up the various registry types can also be seen inline by clicking *'Need some help setting up your registry?'* near the bottom of the modal.

### Docker V2 Regsitry

Regular docker v2 registries include dockerhub, quay.io, artifactory, docker registry v2 container, redhat public container registry, and many others. Generally, if you can execute a ‘docker login’ with a pair of credentials, Anchore can use those.

- **Registry**
  Hostname or IP of your registry endpoint, with an optional port
  Ex: docker.io, mydocker.com:5000, 192.168.1.20:5000

- **Type**
  Set this to docker_v2

- **Username**
  Username that has access to the registry

- **Password**
  Password for the specified user

### Amazon Web Services Registry (AWS ECR)

- **Registry**
  The ECR endpoint hostname
  Ex: 123456789012.dkr.ecr.us-east-1.amazonaws.com

- **Type**
  Set this to **awsecr**

For **Username** and **Password**, there are three different modes that require different settings when adding an ECR registry, depending on where your Anchore Engine is running and how your AWS IAM settings are configured to allow access to a given ECR registry.

1. API Keys
    Provide access/secret keys from an account or IAM user. We highly recommend using a dedicated IAM user with specific access restrictions for this mode.

    - **Username**
      AWS access key

    - **Password**
      AWS secret key

2. Local Credentials
    Uses the AWS credentials found in the local execution environment for Anchore Engine (Ex. env vars, ~/.aws/credentials, or instance profile).

    - **Username**
      Set this to **awsauto**

    - **Password**
      Set this to **awsauto**

3. ECR Assume Role
    To have Anchore Engine assume a specific role different from the role it currently runs within, specify a different role ARN. Anchore Engine will use the execution role (as in iamauto mode from the instance/task profile) to assume a different role. The execution role must have permissions to assume the role requested.

    - **Username**
      Set this to **_iam_role**

    - **Password**
      The desired role's ARN

For more information, see: [Working with Amazon ECR Registry Credentials](/docs/using/cli_usage/registries/ecr_configuration)


### Google Container Registry (GCR)

When working with Google Container Registry, it is recommended that you use service account JSON keys rather than the short lived access tokens. Learn more about how to generate a JSON key here.

- **Registry**
  GCR registry hostname endpoint
  Ex: gcr.io, us.gcr.io, eu.gcr.io, asia.gcr.io

- **Type**
  Set this to **docker_v2**

- **Username**
  Set this to **_json_key**

- **Password**
  Full JSON string of your JSOn key (the content of the key.json file you got from GCR)

For more information, see: [Working with Google Container Registry (GCR) Credentials](/docs/using/cli_usage/registries/gcr_configuration)

### Microsoft Azure Registry

To use an Azure Registry, you can configure Anchore to use either the admin credential(s) or a service principal. Refer to Azure documentation for differences and how to setup each.

- **Registry**
  The login server
  Ex. myregistry1.azurecr.io

- **Type**
  Set this to **docker_v2**

1. Admin Account
    **Username**
        The username in the 'az acr credentials show --name <registry name>' output

    **Password**
        The password or password2 value from the 'az acr credentials show' command result

2. Service Principal
    **Username**
        The service principal app id
    
    **Password**
        The service principal password

For more information, see: [Working with Azure Registry Credentials](/docs/using/cli_usage/registries/acr_configuration)