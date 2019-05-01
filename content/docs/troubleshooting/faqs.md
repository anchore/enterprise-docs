---
title: "Frequently Asked Questions"
linkTitle: "FAQs"
weight: 2
---

# Anchore Troubleshooting FAQs

For each of the following frequently asked questions, read the [General Troubleshooting Approach Guide](/docs/troubleshooting) first, then following the data from there, follow the query specific answers below. 


<!--ts-->
   * [Unauthorized error when using the Anchore CLI](#unauthorized-error-when-using-the-anchore-cli)
   * [No vulnerability results for an analyzed image](#no-vulnerability-results-for-an-analyzed-image)
   * [My image will not analyze](#my-image-will-not-analyze)
   * [Unable to access private registry](#unable-to-access-private-registry)
   * [Anchore Engine container keeps exiting](#anchore-engine-container-keeps-exiting)
<!--te-->

**Note:** As stated in the [General Troubleshooting Approach Guide](/docs/troubleshooting), passing the `--debug` option to any Anchore CLI command can often help narrow down particular issues. 

## Unauthorized error when using the Anchore CLI

If you run into an `"Unauthorized"` error, verify you have configured the Anchore CLI correctly, as this error is most commonly seen when the Username, Password, or Service URL are improperly set. 

By default the Anchore CLI will try to connect to the Anchore Engine at `http://localhost:8228/v1` with no authentication. The username, password and URL for the server can be passed to the Anchore CLI as command line arguments. 

```
--u   TEXT   Username     eg. admin (default)
--p   TEXT   Password     eg. foobar (default)
--url TEXT   Service URL  eg. http://localhost:8228/v1
```

Rather than passing these parameters for every call to the cli they can be stores as environment variables.

```
ANCHORE_CLI_URL=http://myserver.example.com:8228/v1
ANCHORE_CLI_USER=admin
ANCHORE_CLI_PASS=foobar
```

**Note:** When passing the parameters through the command line, order matters. For example, `anchore-cli --url http://localhost:8228/v1 --u admin --p foobar system status`

## No vulnerability results for an analyzed image

In order to return vulnerability results on analyzed images feed data must be synced. 

### Verifying feed data

The following command will report a list of feeds synced by Anchore: `anchore-cli system feeds list`

```
anchore-cli system feeds list
Feed                   Group                  LastSync                          RecordCount        
nvd                    nvddb:2002             2019-02-25T21:35:12.802608        6745               
nvd                    nvddb:2003             2019-02-25T21:35:13.188204        1547               
nvd                    nvddb:2004             2019-02-25T21:35:13.774093        2702               
nvd                    nvddb:2005             2019-02-25T21:35:14.281344        4749               
nvd                    nvddb:2006             2019-02-25T21:39:01.936476        7127               
nvd                    nvddb:2007             2019-02-25T21:39:02.432799        6556               
nvd                    nvddb:2008             2019-02-25T22:29:19.704624        7147               
nvd                    nvddb:2009             2019-02-25T22:29:20.292788        4964               
nvd                    nvddb:2010             2019-02-25T22:29:20.720235        5073               
nvd                    nvddb:2011             2019-02-25T21:30:43.003078        4621               
nvd                    nvddb:2012             2019-02-25T21:35:11.663650        5549               
nvd                    nvddb:2013             2019-02-25T21:39:01.289722        6160               
nvd                    nvddb:2014             2019-02-25T21:42:11.148478        8493               
nvd                    nvddb:2015             2019-02-25T21:44:55.773423        8023               
nvd                    nvddb:2016             2019-02-25T21:48:13.150698        9872               
nvd                    nvddb:2017             2019-02-25T22:03:35.550272        15162              
nvd                    nvddb:2018             2019-02-25T22:26:12.131914        13541              
nvd                    nvddb:2019             2019-02-25T22:29:19.116614        963                
vulnerabilities        alpine:3.3             2019-04-28T13:04:11.054665        457                
vulnerabilities        alpine:3.4             2019-04-28T13:04:11.283342        681                
vulnerabilities        alpine:3.5             2019-04-28T13:04:10.741848        875                
vulnerabilities        alpine:3.6             2019-04-28T13:04:13.506188        1051               
vulnerabilities        alpine:3.7             2019-04-28T13:04:10.510544        1125               
vulnerabilities        alpine:3.8             2019-04-28T13:04:08.909376        1220               
vulnerabilities        alpine:3.9             2019-04-28T13:04:08.308430        1218               
vulnerabilities        amzn:2                 2019-04-28T13:04:14.120807        163                
vulnerabilities        centos:5               2019-04-28T13:04:10.278929        1323               
vulnerabilities        centos:6               2019-04-28T13:04:12.089106        1328               
vulnerabilities        centos:7               2019-04-28T13:04:13.261358        778                
vulnerabilities        debian:10              2019-04-28T13:04:12.408950        20095              
vulnerabilities        debian:7               2019-04-28T13:04:12.643238        20455              
vulnerabilities        debian:8               2019-04-28T13:04:15.673385        21557              
vulnerabilities        debian:9               2019-04-28T13:04:07.625729        20319              
vulnerabilities        debian:unstable        2019-04-28T13:04:13.900741        20952              
vulnerabilities        ol:5                   2019-04-28T13:04:14.578852        1230               
vulnerabilities        ol:6                   2019-04-28T13:04:11.595896        1401               
vulnerabilities        ol:7                   2019-04-28T13:04:11.857659        889                
vulnerabilities        ubuntu:12.04           2019-04-28T13:04:09.166082        14948              
vulnerabilities        ubuntu:12.10           2019-04-28T13:04:07.207705        5652               
vulnerabilities        ubuntu:13.04           2019-04-28T13:04:09.730803        4127               
vulnerabilities        ubuntu:14.04           2019-04-28T13:04:10.044314        18504              
vulnerabilities        ubuntu:14.10           2019-04-28T13:04:14.350013        4456               
vulnerabilities        ubuntu:15.04           2019-04-28T13:04:07.980058        5789               
vulnerabilities        ubuntu:15.10           2019-04-28T13:04:16.144666        6513               
vulnerabilities        ubuntu:16.04           2019-04-28T13:04:12.989542        15484              
vulnerabilities        ubuntu:16.10           2019-04-28T13:04:14.885677        8647               
vulnerabilities        ubuntu:17.04           2019-04-28T13:04:15.133018        9157               
vulnerabilities        ubuntu:17.10           2019-04-28T13:04:15.914109        7935               
vulnerabilities        ubuntu:18.04           2019-04-28T13:04:09.501847        9736               
vulnerabilities        ubuntu:18.10           2019-04-28T13:04:15.418772        7823               
vulnerabilities        ubuntu:19.04           2019-04-28T13:04:08.653333        6274 
```

### Waiting for Anchore feed data to sync

**Note:** Upon a fresh installation of Anchore Engine, the system will take some time to bootstrap. CVE data for Linux distributions such as Alpine, CentOS, Debian, Oracle, Red Hat and Ubuntu will be downloaded. The initial sync may take anywhere from  10 to 60 minutes depending on the speed of your network connection. 

You can run the following command to wait until Anchore Engine is available and ready. This can be useful when waiting for vulnerability data to sync on intial installation. `anchore-cli system wait`

```
# Blocking operation that will return when anchore-engine is available and ready

root@4c0a95557659:/anchore-engine# anchore-cli system wait
Starting checks to wait for anchore-engine to be available timeout=-1.0 interval=5.0
API availability: Checking anchore-engine URL (http://localhost:8228)...
API availability: Success.
Service availability: Checking for service set (catalog,apiext,policy_engine,simplequeue,analyzer)...
Service availability: Success.
Feed sync: Checking sync completion for feed set (vulnerabilities)...
Feed sync: Success.
```

### Logs

If you are running into feed sync failures a good place to begin investigation is the the policy engine service logs (`/var/log/anchore/anchore-policy-engine.log`)

## My image will not analyze

Image analysis is performed as a distinct, asynchronous, and scheduled task driven by queues that analyzer workers periodically poll. Image records have a small state-machine as follows:

**Note:** In order for an image to move from 'not_analyzed' to 'analyzing', you need a healthy catalog, simplequeue, and analyzer service up and running. See the verifying services section in the [General Troubleshooting Approach Guide](/docs/troubleshooting) for more information.

### Logs

If you run into issues with images failing analysis a good place to start inspecting is the analyzer logs (`/var/log/anchore/anchore-worker.log`)

The analyzer is the only component that can set an image state to 'analysis_failed', so you should be able to see a record of what happened. 

## Unable to access private registry

Anchore Engine will attempt to download images from any registry without requiring further configuration.
However if your registry requires authentication then the registry and corresponding credentials will need to be defined.

### The --insecure option

Anchore Engine will only pull images from a TLS/SSL enabled registry. If the registry is protected with a self signed certificate or a certificated signed by an unknown certificate authority then the `--insecure` option can be passed which instructs the Anchore Engine not to validate the certificate.

`anchore-cli registry add REGISTRY USERNAME PASSWORD --insecure`

### The --skip-validate option

Anchore Engine attempts to perform a credential validation upon registry addition, but there are cases where a credential can be valid but the validation routine can fail (in particular, credential validation methods are changing for public registries over time).  If you are unable to add a registry but believe that the credential you are providing is valid, or you wish to add a credential to anchore before it is in place in the registry, you can bypass the registry credential validation process using the `--skip-validate` option to the 'registry add' command.

`anchore-cli registry add REGISTRY USERNAME PASSWORD --skip-validate`

## Anchore Engine container keeps exiting

The first step here should be to inspect the logs for the exited container. For Docker, running `docker logs <exited container id> ` should return the reason the container exited. 

If you see `[MainThread] [anchore_manager.cli.service/start()] [ERROR] Error: cannot locate configuration file (/config/config.yaml)` in the logs, you should verify you have set up the directory for your Anchore installation correctly. 

If you are following the Anchore engine quickstart guide, your directory structure should look like the following:

```
cd ~/aevolume
# find .
.
./config
./config/config.yaml
./db
./docker-compose.yaml
```

If you still see the above error, take a look at the `docker-compose.yaml` file and confirm that the config volume mount definition is correct. 

Example: 

```
volumes:
   - ./config:/config/:z
```

**Note:** If you are following the quickstart guide, you should not need to make any modifications to the configuration files, they are designed to work out of the box.
