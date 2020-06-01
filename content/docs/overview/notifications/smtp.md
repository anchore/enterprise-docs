---
title: "SMTP"
weight: 4
---

Notifications to SMTP server are in the form of html and plain text message packets

### Requirements

To receive notifications

1. The following SMTP server information is required
     * Host name/address
     * Port number
     * From address
     * To address
     * (Optional) username
     * (Optional) password
     * (Optional) use tls to encrypt connection
2. Create an SMTP endpoint configuration in the Notifications service either via [Enterprise UI]({{< ref "/docs/using/ui_usage/notifications" >}}) or the API directly
