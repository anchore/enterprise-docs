---
title: "Image Analysis Process"
weight: 1
---

Image analysis is performed as a distinct, asynchronous, and scheduled task driven by queues that analyzer workers periodically poll. Image records have a small state-machine as follows:

![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36021354861/original/YSqCPgSG77OXMHOjx7P2Do9Bld4Zar5gVw.jpg?1542049669)

The analysis process is composed of several steps and utilizes several system components. The, basic flow of that task is as follows:

![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36020808611/original/9W4uwUyT5suYarn83yOGsWPynNnxtPJKdw.jpg?1541503856)

Adding more detail, the API call trace between services looks approximately like (somewhat simplified for ease of presentation):

![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36020808625/original/IH32gpqyEoHW_CE-oe3JhkMojY82zCWcXQ.jpg?1541503874)