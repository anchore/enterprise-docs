---
title: "Scanning Repositories"
weight: 2
---

Individual images can be added to the Anchore Engine engine using the `image add` command. This may be performed by a CI/CD plugin such as Jenkins or manually by a user with the CLI or API.


The Anchore Engine can also be configured to scan repositories and automatically add any tags found in the repository. Once added, the Anchore Engine will poll the registry to look for changes at a user configurable interval.
This interval is specified in the Anchore Engine configuration file: config.yaml within the services -> Catalog configuration stanza.

```
cycle_timers:
      image_watcher: 3600
      repo_watcher: 60
```

In this example the repo is polled for updates every minute (60 seconds).

### Adding Repositories

The `repo add` command instructs the Anchore Engine to add the specified repository watch list.

`$ anchore-cli repo add repo.example.com/apps`

By default the Anchore Engine will automatically add the discovered tags to the list of subscribed tags (see [Working with Subscriptions]()) this behavior can be overridden by passing the `--noautosubscribe` option.

The Anchore Engine needs to find a single TAG in the repository before the repository can be added to the watch list. By default the Anchore Engine will look for a tag named latest this behavior can be overridden using the `--lookuptag` option.

In the following example the *apps* repo is known to contain a dev tag. 

`$ anchore-cli repo add repo.example.com/apps --lookuptag dev`

### Listing Repositories

The `repo list` command will show the repositories monitored by the Anchore Engine.

```
$ anchore-cli repo list

Repository                   Watched        TagCount        
docker.io/anchore/test        True           15              
docker.io/anchore/prod        True           25    
```

### Deleting Repositories

The `del` option can be used to instruct the Anchore Engine to remove the repository from the watch list. Once the repository record has been deleted no further changes to the repository will be detected by the Anchore Engine.

**Note:** No existing image data will be removed from the Anchore Engine.

`$ anchore-cli repo del repo.example.com/myrepo`

### Unwatching Repositories

When a repository is added the Anchore Engine will monitor the repository for new and updated tags. This behavior can be disabled preventing the Anchore Engine from monitoring the repository for changes.

In this case the `repo list` command will show false in the Watched column for this registry.

`$ anchore-cli repo unwatch repo.example.com/myrepo`

### Watching Repositories

The repo watch command instructs the Anchore Engine to monitor a repository for new and updated tags. By default repositories added to the Anchore Engine are automatically watched. This option is only required if a repository has been manually unwatched.

`$ anchore-cli repo watch repo.example.com/myrepo`