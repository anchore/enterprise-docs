---
title: "Trusted and Blacklisted Images"
weight: 1
---

![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36006094217/original/wt2cjvwZk4crP4kAvOZCcr2UthgiQhCepA?1525627974)

The *Trusted / Blacklisted Images* tab is split into two sub tabs for:

- Trusted Images
  A list of images which will always pass policy evaluation irrespective of any policies that are mapped to them.

- Blacklisted Imags
  A list if Images which will always fail policy evaluation irrespective of any policies that are mapped to them.

Images can be referenced in one of three ways:

1. By name: including the registry, repository and tag
   eg. docker.io/library/centos:latest

2. By image id: including the full image ID
   eg. e934aafc22064b7322c0250f1e32e5ce93b2d19b356f4537f5864bd102e8531f

3. By digest: including the registry, repository and digest of the image.
   eg.  docker.io/library/centos@sha256:989b936d56b1ace20ddf855a301741e52abca38286382cba7f44443210e96d16

For most use cases Anchore recommends that the digest is used to reference the image since an image name is ambiguous, as over time different images may be tagged with the same name. 

If an image may appear on both the Trusted Images and Blacklisted Images lists then the blacklist takes precedence and the image will be failed.

**Note:** See Evaluating Images against Policies for details on image policy evaluation.

The Trusted Images and Blacklisted Images tabs provide similar user interfaces allowing the list of trusted, or blacklisted, images to be maintained.

The Trusted Images list will show a list of any Trusted Images defined by the system includes the following fields:

- **Name**
  A user friendly name to identify the image(s)

- **Type**
  Describes how the image has been specified. By **Name**, **ID**, or **Digest**

- **Image**
  The specification used to define the image

  The ![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36006094747/original/CoIhZSfXVAmW9shhdqSKpKVn-OXSlFDe1Q?1525630095) button can be used to copy the image specification into the clipboard. 

  An existing image may be deleted using the ![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36006094767/original/uPDjQjg9Qvb2KGPRLqulfEBk3L6dS3aGJg?1525630161) or edited by pressed the ![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36006094770/original/5LXOK8IYyQzOg6tvabTrghSBC8kF6lIUIg?1525630202) button.

![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36005886323/original/AOLOlqn6NHiXKvADnajLL2jEX9XDIRASxA.png?1525314097)

### Adding New Trusted or Blacklisted Images.

New Images can by added by pressing the ![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36006094857/original/xRlErqYUNOPZ81bwRlXEGYMJF0kCX_r34Q?1525630716) or ![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36006094862/original/Zjw7CjGfLed7izhHveqdyHcpdq7VOQs2sg?1525630774) buttons.

The workflow for adding Trusted or Blacklisted images is identical. In the example below we will add new Trusted images.

The user will be prompted for a name to reference this image. The name does not have to be unique but it is recommended to that the identifier is descriptive.

![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36005886347/original/iRGPTMWfGo7SqkH5wKX3iFYu3W3KZmJUcQ.png?1525314185)

Once the image item has been named clicking on the Identify Image will bring up drop down to select how the image is identified: by Name, Image ID or Image Digest.

![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36005886348/original/RDJCRVho47fh2VA7k8IKkJk_Nh0HvWA2QQ.png?1525314192)

The Add Image dialog will present a different set of input fields depending on the Identify Image selection.

### Adding an Image by Image ID 

The full Image ID should be entered. This will be a 64 hex characters. There are a variety of ways to retrieve the ID of an image including using the anchore-cli, Anchore UI and Docker command.

![alt text](http://static1.squarespace.com/static/53ce4d58e4b09f1cf081aa96/t/53eda86ce4b03190fb1eda4b/1423470352399/?format=1500w) Using Anchore CLI

```
$ anchore-cli image get library/debian:latest | grep Image\ ID
Image ID: 8626492fecd368469e92258dfcafe055f636cb9cbc321a5865a98a0a6c99b8dd
```

![alt text](http://static1.squarespace.com/static/53ce4d58e4b09f1cf081aa96/t/53eda86ce4b03190fb1eda4b/1423470352399/?format=1500w) Using Docker CLI

```
$ docker images --no-trunc debian:latest

REPOSITORY          TAG                 IMAGE ID                                                                  CREATED             SIZE
docker.io/debian    latest              sha256:8626492fecd368469e92258dfcafe055f636cb9cbc321a5865a98a0a6c99b8dd   3 days ago          101 MB
```

By default the docker CLI displays a short ID, the long ID is required and it can be displayed by using the --no-trunc parameter.

**Note:** The algorithm (sha256:) should not be entered into the Image ID field.

![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36005886349/original/zR2O5ApOjQZ9HTbMCz-IGRM1OVnmHg0Bbg.png?1525314201)

### Adding an Image by Digest

When adding an image by Digest the following fields are required:

- Registry
  eg. docker.io

- Repository
  eg. library/debian

- Digest
  eg. sha256:de3eac83cd481c04c5d6c7344cd7327625a1d8b2540e82a8231b5675cef0ae5f

The full identifier for this image is: docker.io/library/debian@sha256:de3eac83cd481c04c5d6c7344cd7327625a1d8b2540e82a8231b5675cef0ae5f
**Note:** The tag is not used when referencing an image by digest.

There are a variety of ways to retrieve the digest of an image including using the anchore-cli, Anchore UI and Docker command.

![alt text](http://static1.squarespace.com/static/53ce4d58e4b09f1cf081aa96/t/53eda86ce4b03190fb1eda4b/1423470352399/?format=1500w) Using Anchore CLI

```
$ anchore-cli image get library/debian:latest | grep Digest
Image Digest: sha256:7df746b3af67bbe182a8082a230dbe1483ea1e005c24c19471a6c42a4af6fa82
```

![alt text](http://static1.squarespace.com/static/53ce4d58e4b09f1cf081aa96/t/53eda86ce4b03190fb1eda4b/1423470352399/?format=1500w) Using Docker CLI

```
$ docker images --digests debian
REPOSITORY          TAG                 DIGEST                                                                    IMAGE ID            CREATED             SIZE
docker.io/debian    latest              sha256:de3eac83cd481c04c5d6c7344cd7327625a1d8b2540e82a8231b5675cef0ae5f   8626492fecd3        1 days ago          101 MB
```

**Note:** Unlike the Image ID entry, the algorithm (sha256:) is required.

![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36005886350/original/WzrxT87HDQbiMyoD1KxzGCaoSFBYK7OzMw.png?1525314206)


### Adding an Image by Name

When adding an image by Name the following fields are required:

- Registry
  eg. docker.io

- Repository
  eg. library/debian

- Tag
  eg. latest.

**Note:** Wild cards are supported, so to trust all images from docker.io you would enter docker.io in the Registry field, and * in the repository and Tag fields.

![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36005886353/original/DkyL07ZSn_sucSEj_n0rajXO403O15sS4Q.png?1525314213)