---
title: "Anchore CLI"
linkTitle: "Anchore CLI"
weight: 4
---

### Introduction

In this section you will learn how to install and configure the Anchore CLI. The Anchore CLI provides a command line interface on top of the Anchore Engine REST API. THe Anchore CLI is published as a Python Package that can be installed from source from the Python PyPI package repository on any platform supporting PyPi. Using the Anchore CLI users can manage and inspect images, policies, subscriptions, and registries. 

You can view the Anchore CLI on [Github](https://github.com/anchore/anchore-cli) or [Docker Hub](https://hub.docker.com/r/anchore/engine-cli/).

#### Installing Anchore CLI on CentOS and Red Hat Enterprise Linux

```
sudo yum install -y epel-release
sudo yum install -y python-pip
pip install --user --upgrade anchorecli
```

#### Installing Anchore CLI on Debian and Ubuntu

```
sudo apt-get update 
sudo apt-get install python-pip
pip install --user --upgrade anchorecli
```

#### Installing Anchore CLI on Mac osX

```
sudo easy_install pip
pip install --user --upgrade anchorecli
```

#### Installing the Anchore CLI from source

```
git clone https://github.com/anchore/anchore-cli
cd anchore-cli
pip install --user --upgrade . 
```

#### Setting the Path

Once installed the anchore-cli utility has been installed you may need to adjust your PATH to ensure that the anchore-cli executable is in the user's path.

The install location is system dependent, governed by PIP and may vary based the distribution on which you are running.
The most common default locations are:

- **Apple macOS:** $HOME/Library/Python/2.7/bin
- **Linux:** $/HOME/.local/bin

You can verify the install location by running the following command:

```
$ python -m site --user-base
/home/myusername/.local
```

Executable files installed by pip --user will be placed in the bin sub directory.

#### Next Steps

Once the Anchore CLI has been installed it now should be configured to access Anchore Enterprise.

To begin, go to [Configuring the Anchore CLI](/docs/installation/anchore_cli/cli_config).
