---
title: "Anchore Enterprise Feeds Advanced API Access"
weight: 1
---

Anchore Enterprise Feeds offers a RESTful API.

API definition is documented using the OpenAPI/Swagger specification and can be accessed at: <hostname:port>/v1/swagger.json

The API is open and read-only, there is no authentication necessary.

### Feed Data API

Data is organized into 'feeds' and 'groups' within a given feed. A feed is a semantic grouping of data but allows different schemas for the data within each group of the feed and allows for finer-grained updates by allowing clients to select the data of interest.

Examples of feeds:

- vulnerabilities - CVE data from upstream sources such as Debian, Red Hat, Alpine, Ubuntu, and Oracle
- packages - Metadata and manifests for upstream application packages, such as npmjs.org and rubygems.org
- nvd - NIST National Vulnerability Database records (CVEs)

Following examples highlight the routes exposed by the service for querying feed data:

#### List the available feeds:

```
$ curl -s "http://feeds.example.com:8448/v1/feeds"

{
    "feeds": [
      {
        "access_tier": 0,
        "description": "Feed record for type nvd",
        "name": "nvd"
      },
      {
        "access_tier": 0,
        "description": "Feed record for type vulnerabilities",
        "name": "vulnerabilities"
      }
    ],
    "next_token": ""
  }

```

#### List the groups available for vulnerability feed data:

```
$ curl -s "http://feeds.example.com:8448/v1/feeds/vulnerabilities"

{
    "groups": [
      {
        "access_tier": 0,
        "description": "Group record for namespace: alpine:3.3 and feed type: vulnerabilities",
        "name": "alpine:3.3"
      }
    ],
    "next_token": ""
  }
```

#### Fetch the vulnerability feed data for debian:9 group:

```
$ curl "http://feeds.example.com:8448/v1/feeds/vulnerabilities/debian:9"

{
    "data": [
      {
        "Vulnerability": {
          "Description": "",
          "FixedIn": [],
          "Link": "https://security-tracker.debian.org/tracker/CVE-2004-1653",
          "Metadata": {
            "NVD": {
              "CVSSv2": {
                "Score": 6.4,
                "Vectors": null
              }
            }
          },
          "Name": "CVE-2004-1653",
          "NamespaceName": "debian:9",
          "Severity": "Negligible"
        }
      }
    ],
    "next_token": "MjAxOC0wMi0xNFQyMTowNToxNC40NjIwMjU="
  }        
```

Responses are paginated and return only up to 1000 records in each page. If there are more than 1000 records in the result set, the server responds with a truncated set of results and a marker encoded in next_token. The client must invoke the request with next_token as a path parameter to receive the next page of results and so on. An empty value for next_token is an indication that the service has exhausted the results for the query

```
$ curl "http://feeds.example.com:8448/v1/feeds/vulnerabilities/debian:9?next_token=MjAxOC0wMi0xNFQyMTowNToxNC40NjIwMjU="

{
    "data": [
      {
        "Vulnerability": {
          "Description": "",
          "FixedIn": [],
          "Link": "https://security-tracker.debian.org/tracker/CVE-2016-2811",
          "Metadata": {
            "NVD": {
              "CVSSv2": {
                "Score": 6.8,
                "Vectors": "AV:N/AC:M/Au:N/C:P/I:P"
              }
            }
          },
          "Name": "CVE-2016-2811",
          "NamespaceName": "debian:9",
          "Severity": "Negligible"
        }
      }
    ],
    "next_token": "MjAxOC0wNC0yMVQwMzoyNjowNy4xMTYzNzI="
  }
```

### Tasks API

Anchore Feed Service has a tasks API for monitoring events. Periodic execution of drivers processing and generating normalized feed data is one such system event that can be tracked via this API.

There are 2 primary task types:

- FeedSyncTask - A meta-task that contains the set of DriverExecutionTasks that are run for each periodic update check for     upstream data. The task_id of the FeedSyncTask is used as the parent_task_id of its subtasks.
- DriverExecutionTask - An execution of a single driver which may provide data for one or more feeds and multiple groups of    data. The parent_task_id of each record points to the FeedSyncTask that initiated it.

#### List all tasks executed by the service since it was first instantiated:

```
$ curl "http://feeds.example.com:8448/v1/tasks"

[
  {
    "driver_id": "nvddb",
    "end_time": "2018-02-14T20:00:32.955063+00:00",
    "feed_id": "nvd",
    "parent_task_id": 1,
    "start_time": "2018-02-14T19:54:18.065878+00:00",
    "started_by": "system",
    "status": "completed",
    "task_id": 2,
    "task_type": "DriverExecutionTask"
  },
  {
    "end_time": "2018-02-14T21:16:49.846366+00:00",
    "start_time": "2018-02-14T19:54:18.058655+00:00",
    "started_by": "system",
    "status": "completed",
    "task_id": 1,
    "task_type": "FeedSyncTask"
  }
]    
```

Filtering the task listing:

Filtering results is done with a 'filter' query parameter with format:

filter=<parameter><operator><value>,<parameter2><operator2><value2>,...<parameterN><operatorN><valueN>

Supported filtering parameters are 'feed_id', 'driver_id' and 'task_type' with '=' operator, and 'task_id' with '>' or '<' operators. For a detailed view of every task use query parameter details=True in the request

```
$ curl "http://feeds.example.com:8448/v1/tasks?filter=driver_id=centos,task_id&gt;470&amp;details=True"
[
  {
    "driver_id": "centos", 
    "end_time": "2018-05-06T17:41:54.304455+00:00", 
    "feed_id": "vulnerabilities", 
    "parent_task_id": 492, 
    "result": {
      "changes": {}
    }, 
    "start_time": "2018-05-06T17:41:44.980816+00:00", 
    "started_by": "system", 
    "status": "completed", 
    "task_id": 495, 
    "task_type": "DriverExecutionTask"
  }, 
  {
    "driver_id": "centos", 
    "end_time": "2018-05-04T18:06:12.222140+00:00", 
    "feed_id": "vulnerabilities", 
    "parent_task_id": 474, 
    "result": {
      "changes": {
        "centos:7": {
          "created": 0, 
          "deleted": 0, 
          "updated": 1
        }
      }
    }, 
    "start_time": "2018-05-04T18:06:02.787274+00:00", 
    "started_by": "system", 
    "status": "completed", 
    "task_id": 477, 
    "task_type": "DriverExecutionTask"
  }
]
```

```
$ curl "http://feeds.example.com:8448/v1/tasks/29"

{
  "end_time": "2018-05-05T02:01:39.102506+00:00", 
  "result": {
    "completed_drivers": [
      "nvddb", 
      "centos", 
      "ubuntu", 
      "ol", 
      "debian", 
      "alpine"
    ], 
    "failed_drivers": [], 
    "skipped_drivers": [
      "npm", 
      "gem"
    ]
  }, 
  "start_time": "2018-05-05T01:34:44.279009+00:00", 
  "started_by": "system", 
  "status": "completed", 
  "sub_tasks": [
    {
      "driver_id": "alpine", 
      "end_time": "2018-05-05T02:01:39.096383+00:00", 
      "feed_id": "vulnerabilities", 
      "parent_task_id": 29, 
      "result": {
        "changes": {}
      }, 
      "start_time": "2018-05-05T02:01:24.552365+00:00", 
      "started_by": "system", 
      "status": "completed", 
      "task_id": 35, 
      "task_type": "DriverExecutionTask"
    }, 
    {
      "driver_id": "debian", 
      "end_time": "2018-05-05T02:01:24.531506+00:00", 
      "feed_id": "vulnerabilities", 
      "parent_task_id": 29, 
      "result": {
        "changes": {}
      }, 
      "start_time": "2018-05-05T01:55:58.151817+00:00", 
      "started_by": "system", 
      "status": "completed", 
      "task_id": 34, 
      "task_type": "DriverExecutionTask"
    }, 
    {
      "driver_id": "ol", 
      "end_time": "2018-05-05T01:55:58.148810+00:00", 
      "feed_id": "vulnerabilities", 
      "parent_task_id": 29, 
      "result": {
        "changes": {}
      }, 
      "start_time": "2018-05-05T01:55:47.451599+00:00", 
      "started_by": "system", 
      "status": "completed", 
      "task_id": 33, 
      "task_type": "DriverExecutionTask"
    }, 
    {
      "driver_id": "ubuntu", 
      "end_time": "2018-05-05T01:55:47.429078+00:00", 
      "feed_id": "vulnerabilities", 
      "parent_task_id": 29, 
      "result": {
        "changes": {}
      }, 
      "start_time": "2018-05-05T01:40:22.597673+00:00", 
      "started_by": "system", 
      "status": "completed", 
      "task_id": 32, 
      "task_type": "DriverExecutionTask"
    }, 
    {
      "driver_id": "centos", 
      "end_time": "2018-05-05T01:40:22.592102+00:00", 
      "feed_id": "vulnerabilities", 
      "parent_task_id": 29, 
      "result": {
        "changes": {}
      }, 
      "start_time": "2018-05-05T01:40:12.437229+00:00", 
      "started_by": "system", 
      "status": "completed", 
      "task_id": 31, 
      "task_type": "DriverExecutionTask"
    }, 
    {
      "driver_id": "nvddb", 
      "end_time": "2018-05-05T01:40:12.432318+00:00", 
      "feed_id": "nvd", 
      "parent_task_id": 29, 
      "result": {
        "changes": {}
      }, 
      "start_time": "2018-05-05T01:34:44.296992+00:00", 
      "started_by": "system", 
      "status": "completed", 
      "task_id": 30, 
      "task_type": "DriverExecutionTask"
    }
  ], 
  "task_id": 29, 
  "task_type": "FeedSyncTask"
}
```