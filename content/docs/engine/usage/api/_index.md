---
title: "Accessing the Anchore Engine API"
linkTitle: "Anchore Engine API"
weight: 3
---

The Anchore Engine can be accessed through a [CLI](https://github.com/anchore/anchore-cli) or via a RESTful API.

The API has be documented using the OpenAPI Specification (Swagger) and the source can be found in the [swagger.yaml](https://github.com/anchore/anchore-engine/blob/master/anchore_engine/services/apiext/swagger/swagger.yaml) document within the external API service.

You can also browse our API on [SwaggerHub](https://app.swaggerhub.com/apis/anchore/anchore-engine/0.1.9).

The JSON definition for the API can be downloaded from a running Anchore Engine service at the following URI:

**http://{servername:port}/v1/swagger.json**

**e.g.**

**http://localhost:8228/v1/swagger.json**

The Engine includes the Swagger UI allowing for the API to be viewed and tested within a web browser. The UI can be accessed at the following URI:

**http://{servername:port}/v1/ui/**

**e.g.**

**http://localhost:8228/v1/ui/**

**Note:** be sure to include the trailing slash for the /v1/ui/ route, otherwise you will get a badly formatted response in your browser.

