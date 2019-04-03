---
title: "Storage"
linkTitle: "Storage"
weight: 8
---

The Anchore Engine uses a PostgreSQL database to store persistent data for images, tags, policies, subscriptions and other artifacts.

A subset of Anchore data is not stored in tabular format in within PostgreSQL database but is instead stored as JSON documents. Within the Anchore Engine these are referred to as archive documents. While these documents are referred to as archives they may represent current data that is still in use, not historic (archived) data. Some examples of data stored as JSON are: policy bundles, image content and manifests.

By default these documents are be stored within the PostgreSQL database however the Anchore Engine can be configured to store archive documents in one of 4 locations:

- PostgreSQL database (default)
- Filesystem 
- S3 Object Store
- Swift Object Store
