---
title: "Anchore Enterprise Reports API Access"
linkTitle: "Reports"
weight: 1
---

Anchore Enterprise Reports provides a [GraphQL](https://graphql.org/) API for direct interaction with the service. GraphQL is a query language for APIs and a runtime for fulfilling those queries. 
 
### Get started

There are different ways of interacting with the Anchore Enterprise Reports GraphQL API. Following sections highlight two different options for exploring the Anchore Enterprise Reports GraphQL schema with a few examples  

#### Interactive GUI
One of the ways of exploring and testing a GraphQL schema is by using [GraphiQL](https://electronjs.org/apps/graphiql). Anchore Enterprise Reports Service has GraphiQL built-in to the service and enabled by default. 

To access it in a running Anchore Enterprise deployment, open http://\<servername:port\>/v1/reports/graphql in a browser and input your Anchore Engine credentials. Click the Docs tab to view the self-describing schema 

![Reports GraphQL Schema](ReportsGraphiQLSchema.png)

More importantly, you can test any of the supported queries. Here is an example of a query for available metrics in the system. Happy querying!

![Reports GraphQL Example](ReportsGraphiQLExample.png)

#### Command line using curl 

You can also use curl to send HTTP requests to Anchore Enterprise Reports API

- Get all the metric values

```bash
$ curl -u <username:password> -X POST "http://<servername:port>/v1/reports/graphql?query=%7BmetricData%7BpageInfo%7BnextToken%20count%7Dresults%7BmetricId%20value%20collectedAt%7D%7D%7D"
```
```json
{
  "data": {
    "metricData": {
      "pageInfo": {
        "nextToken": "MjAxOS0wNC0yNlQxODozOTozNC4xNzA5Njd8dnVsbmVyYWJpbGl0aWVzLnRhZ3MuY3VycmVudC51bmtub3du",
        "count": 1000
      },
      "results": [
        {
          "metricId": "vulnerabilities.tags.current.unknown",
          "value": "55",
          "collectedAt": "2019-04-30T20:48:28.482534"
        },
        {
          "metricId": "vulnerabilities.tags.current.negligible",
          "value": "402",
          "collectedAt": "2019-04-30T20:48:28.482534"
        },
        {
          "metricId": "vulnerabilities.tags.current.medium",
          "value": "1560",
          "collectedAt": "2019-04-30T20:48:28.482534"
        },
        {
          "metricId": "vulnerabilities.tags.current.low",
          "value": "576",
          "collectedAt": "2019-04-30T20:48:28.482534"
        },
        ...
      ]
    }
  }
}
```

- Get a list of repositories and a count of tags within each repository that resulted in successful policy evaluation check 

```bash
$ curl -u <username:password> -X POST "http://<servername:port>/v1/reports/graphql?query=%7BpolicyEvaluationsByTag(filter%3A%7BpolicyEvaluation%3A%7Bresult%3APass%2Creason%3Apolicy_evaluation%7D%7D)%7BpageInfo%7BnextToken%20count%7Dresults%7BregistryName%20repositories%7BrepositoryName%20tagsCount%7D%7D%7D%7D"
```
```json
{
  "data": {
    "policyEvaluationsByTag": {
      "pageInfo": {
        "nextToken": null,
        "count": 3
      },
      "results": [
        {
          "registryName": "docker.io",
          "repositories": [
            {
              "repositoryName": "library/ubuntu",
              "tagsCount": 16
            },
            {
              "repositoryName": "library/debian",
              "tagsCount": 4
            },
            {
              "repositoryName": "library/alpine",
              "tagsCount": 1
            }
          ]
        }
      ]
    }
  }
}
```

- Get a list of repositories and a count of tags within each repository that are affected by a `High` severity vulnerability

```bash
$ curl -u <username:password> -X POST "http://<servername:port>/v1/reports/graphql?query=%7BtagsByVulnerability(filter%3A%7Bvulnerability%3A%7Bseverity%3AHigh%7D%7D)%7BpageInfo%7BnextToken%20count%7Dresults%7BvulnerabilityId%20links%20registries%7BregistryName%20repositories%7BrepositoryName%20tagsCount%7D%7D%7D%7D%7D%0A"
``` 
```json
{
  "data": {
    "tagsByVulnerability": {
      "pageInfo": {
        "nextToken": null,
        "count": 3
      },
      "results": [
        {
          "vulnerabilityId": "CVE-2019-9924",
          "links": [
            "https://security-tracker.debian.org/tracker/CVE-2019-9924"
          ],
          "registries": [
            {
              "registryName": "docker.io",
              "repositories": [
                {
                  "repositoryName": "library/node",
                  "tagsCount": 10
                }
              ]
            }
          ]
        },
        {
          "vulnerabilityId": "CVE-2019-9169",
          "links": [
            "https://security-tracker.debian.org/tracker/CVE-2019-9169"
          ],
          "registries": [
            {
              "registryName": "docker.io",
              "repositories": [
                {
                  "repositoryName": "library/node",
                  "tagsCount": 1
                }
              ]
            }
          ]
        },
        {
          "vulnerabilityId": "CVE-2019-9003",
          "links": [
            "https://security-tracker.debian.org/tracker/CVE-2019-9003"
          ],
          "registries": [
            {
              "registryName": "docker.io",
              "repositories": [
                {
                  "repositoryName": "library/node",
                  "tagsCount": 2
                }
              ]
            }
          ]
        }
      ]
    }
  }
}
```
- Get Anchore Enterprise Reports GraphQL schema (introspection)

```bash
$ curl -u <username:password> -X POST "http://<servername:port>/v1/reports/graphql?query=%7B__schema%7BqueryType%7Bname%20description%20fields%7Bname%20description%20args%7Bname%20description%20type%7Bname%20kind%7D%7D%7D%7D%7D%7D%0A"

```
```json
{
  "data": {
    "__schema": {
      "queryType": {
        "name": "Query",
        "description": "Anchore Enterprise Reporting GraphQL Interface",
        "fields": [
          {
            "name": "tagsByVulnerability",
            "description": "Returns a list of unique vulnerabilities and a hierarchical view of tags affected by each vulnerability",
            "args": [
              {
                "name": "limit",
                "description": "Number of items per page",
                "type": {
                  "name": "Int",
                  "kind": "SCALAR"
                }
              },
              {
                "name": "nextToken",
                "description": "Opaque token for paginating results",
                "type": {
                  "name": "String",
                  "kind": "SCALAR"
                }
              },
              {
                "name": "filter",
                "description": null,
                "type": {
                  "name": "VulnerabilityQueryFilter",
                  "kind": "INPUT_OBJECT"
                }
              }
            ]
          },
          {
            "name": "imagesByVulnerability",
            "description": "Returns a list of unique vulnerabilities and the images affected by each vulnerability",
            "args": [
              {
                "name": "limit",
                "description": "Number of items per page",
                "type": {
                  "name": "Int",
                  "kind": "SCALAR"
                }
              },
              {
                "name": "nextToken",
                "description": "Opaque token for paginating results",
                "type": {
                  "name": "String",
                  "kind": "SCALAR"
                }
              },
              {
                "name": "filter",
                "description": null,
                "type": {
                  "name": "VulnerabilityQueryFilter",
                  "kind": "INPUT_OBJECT"
                }
              }
            ]
          },
          {
            "name": "artifactsByVulnerabilities",
            "description": "Returns a list of unique vulnerabilities and the artifacts affected by each vulnerability",
            "args": [
              {
                "name": "limit",
                "description": "Number of items per page",
                "type": {
                  "name": "Int",
                  "kind": "SCALAR"
                }
              },
              {
                "name": "nextToken",
                "description": "Opaque token for paginating results",
                "type": {
                  "name": "String",
                  "kind": "SCALAR"
                }
              },
              {
                "name": "filter",
                "description": null,
                "type": {
                  "name": "VulnerabilityQueryFilter",
                  "kind": "INPUT_OBJECT"
                }
              }
            ]
          },
          {
            "name": "policyEvaluationsByTag",
            "description": "Returns policy evaluations for tags in a hierarchical view",
            "args": [
              {
                "name": "limit",
                "description": "Number of items per page",
                "type": {
                  "name": "Int",
                  "kind": "SCALAR"
                }
              },
              {
                "name": "nextToken",
                "description": "Opaque token for paginating results",
                "type": {
                  "name": "String",
                  "kind": "SCALAR"
                }
              },
              {
                "name": "filter",
                "description": null,
                "type": {
                  "name": "PolicyEvaluationsQueryFilter",
                  "kind": "INPUT_OBJECT"
                }
              }
            ]
          },
          {
            "name": "metrics",
            "description": "Lists the available metrics in the system",
            "args": [
              {
                "name": "limit",
                "description": "Number of items per page",
                "type": {
                  "name": "Int",
                  "kind": "SCALAR"
                }
              },
              {
                "name": "nextToken",
                "description": "Opaque token for paginating results",
                "type": {
                  "name": "String",
                  "kind": "SCALAR"
                }
              }
            ]
          },
          {
            "name": "metricData",
            "description": "Lists metric data points in a chronologically descending order",
            "args": [
              {
                "name": "limit",
                "description": "Number of items per page",
                "type": {
                  "name": "Int",
                  "kind": "SCALAR"
                }
              },
              {
                "name": "nextToken",
                "description": "Opaque token for paginating results",
                "type": {
                  "name": "String",
                  "kind": "SCALAR"
                }
              },
              {
                "name": "filter",
                "description": null,
                "type": {
                  "name": "MetricDataFilter",
                  "kind": "INPUT_OBJECT"
                }
              }
            ]
          }
        ]
      }
    }
  }
}
```