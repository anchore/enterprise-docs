---
title: "Using the AnchoreCTL Enterprise CLI"
linkTitle: "Using the AnchoreCTL Enterprise CLI"
weight: 3
---

The AnchoreCTL Enterprise CLI provides a command line interface on top of the Anchore Enterprise & Engine REST APIs. AnchoreCTL is published as a Cobra-CLI Go Binary that can be installed from a public S3 bucket. Using AnchoreCTL, users can manage and inspect images, manage their false-positive management settings, manage their runtime inventory settings, interact with the runtime compliance API, and even generate/upload image SBOMs.

If you have not installed AnchoreCTL, please refer to the [installation guide]({{< ref "/docs/installation/anchorectl" >}}).

The usage guide lives with the binary itself. After installing, just run `anchorectl -h` to get a full list of the supported commands and command line arguments. 