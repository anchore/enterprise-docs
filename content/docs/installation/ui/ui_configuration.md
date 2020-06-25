---
title: "Enterprise UI Configuration"
linkTitle: "UI Configuration"
weight: 2
---

The Enterprise UI service has some static configuration options that are read from `/config/config-ui.yaml` inside the UI container image when the system starts up.

The configuration is designed to not require any modification when using the quickstart (docker-compose) or production (Helm) methods of deploying Anchore Enterprise.  If modifications are desired, the options, their meanings, and environment overrides are listed below for reference:

* The (required) `license_path` key specifies the location of the local system folder containing the `license.yaml` license file required by the Anchore Enterprise UI web service for product activation. This value can be overridden by using the `ANCHORE_LICENSE_PATH` environment variable.
    ```
    license_path: '/'
    ```

* The (required) `engine_uri` key specifies the address of the Anchore Engine service. The value must be a string containing a properly-formed 'http' or 'https' URI.  This value can be overridden by using the `ANCHORE_ENGINE_URI` environment variable.
    ```
    engine_uri: 'http://engine-api:8228/v1'
    ```

* The (required) `redis_uri` key specifies the address of the Redis service. The value must be a string containing a properly-formed 'http', 'https', or `redis` URI. Note that the default configuration uses the REdis Serialization Protocol (RESP). This value can be overridden by using the `ANCHORE_REDIS_URI` environment variable.
    ```
    redis_uri: 'redis://enterprise-ui-redis:6379'
    ```

* The (required) `appdb_uri` key specifies the location and credentials for the postgres DB endpoint used by the UI.  The value must contain the host, port, DB user, DB password, and DB name. This value can be overridden by using the `ANCHORE_APPDB_URI` environment  variable.
    ```
    appdb_uri: 'postgres://<db-user>:<db-pass>@<db-host>:<db-port>/<db-name>'
    ```

* The (required) `reports_uri` key specifies the address of the Reports service. The value must be a string containing a properly-formed 'http' or 'https' URI and can be overridden by using the `ANCHORE_REPORTS_URI` environment variable.

    Note that the presence of an uncommented `reports_uri` key in this file (even if unset, or set with an invalid value) instructs the Anchore Enterprise UI web service that the Reports feature *must* be enabled.
    ```
    reports_uri: 'http://enterprise-reports:8228/v1'
    ```

* The (optional) `rbac_uri` key specifies the address of the Role-Based Authentication Control (RBAC) service. The value must be a string containing a properly-formed 'http' or 'https' URI, and can be overridden by using the
`ANCHORE_RBAC_URI` environment variable.

    Note that the presence of an uncommented `rbac_uri` key in this file (even if unset, or set with an invalid value) instructs the Anchore Enterprise UI web service that the RBAC feature *must* be enabled. If the RBAC service cannot subsequently be reached by the web service, the communication failure will be handled in the same manner as an Anchore Engine service outage.
    ```
    rbac_uri: 'http://enterprise-rbac-manager:8228/v1'
    ```

* The (optional) `enable_ssl` key specifies if SSL is enabled in the web app container. The value must be a Boolean, and defaults to `False` if unset. This value can be overridden by using the `ANCHORE_ENABLE_SSL` environment variable.
    ```
    enable_ssl: False
    ```

* The (optional) `enable_proxy` key specifies whether to trust a reverse proxy when setting secure cookies (via the `X-Forwarded-Proto` header). The value must be a  Boolean, and defaults to `False` if unset. In addition, SSL must be enabled for this to work. This value can be overridden by using the `ANCHORE_ENABLE_PROXY` environment variable.
    ```
    enable_proxy: False
    ```

* The (optional) `allow_shared_login` key specifies if a single set of user credentials can be used to start multiple Anchore Enterprise UI sessions; for example, by multiple users across different systems, or by a single user on a single system across multiple browsers.

    When set to `False`, only one session per credential is permitted at a time, and logging in will invalidate any other sessions that are using the same set of credentials. If this property is unset, or is set to anything other than a Boolean, the web service will default to `True`.
    
    Note that setting this property to `False` does not prevent a single session from being viewed within multiple *tabs* inside the same browser. This value can be overridden by using the `ANCHORE_ALLOW_SHARED_LOGIN` environment variable.
    ```
    allow_shared_login: True
    ```

* The (optional) `redis_flushdb` key specifies if the Redis datastore containing
user session keys and data is emptied on application startup. If the datastore
is flushed, any users with active sessions will be required to re-authenticate.

    If this property is unset, or is set to anything other than a Boolean, the web
service will default to `True`.
This value can be overridden by using the `ANCHORE_REDIS_FLUSHDB` environment
variable.
    ```
    redis_flushdb: True
    ```


* The (optional) `policy_hub_uri` key specifies the address of a Policy Hub
service. The value must be a string containing a properly-formed 'http' or
'https' URI, and can be overridden by using the `ANCHORE_POLICY_HUB_URI`
environment variable.

    When this value is set, the Policy Hub component is enabled within the
Policy Manager view (`/policy`). Note that the availability and integrity of
Policy Hub data is determined by this component at run-time when this
component is accessed.

    ```
    policy_hub_uri: 'http://hub.anchore.io'
    ```

* The (optional) `custom_links` key allows a list of up to 10 external links to
be provided (additional items will be excluded). The top-level `title` key
provided the label for the menu (if present, otherwise the string "Custom
External Links" will be used instead).

    Each link entry must have a title of greater than 0-length and a valid URI.
If either item is invalid, the entry will be excluded.

    ```
    custom_links:
      title: Custom External Links
      links:
      - title: Example Link 1
        uri: https://example.com
      - title: Example Link 2
        uri: https://example.com
      - title: Example Link 3
        uri: https://example.com
      - title: Example Link 4
        uri: https://example.com
      - title: Example Link 5
        uri: https://example.com
      - title: Example Link 6
        uri: https://example.com
      - title: Example Link 7
        uri: https://example.com
      - title: Example Link 8
        uri: https://example.com
      - title: Example Link 9
        uri: https://example.com
      - title: Example Link 10
        uri: https://example.com
    ```

* The (optional) `enable_add_repositories` key specifies if repositories can be
added via the application interface by either administrative users or standard
users. In the absence of this key, the default is `True`.

    In the absence of one or all of the properties, the default is also `True`.
Thus, this key, and a child key corresponding to an account type must be
explicitly set to `False` for the feature to be disabled for that account.

    ```
    enable_add_repositories:
      admin: True
      standard: True
    ```
---
**NOTE:** The latest default UI configuration file can always be extracted from the Enterprise UI container to review the latest options, environment overrides and descriptions of each option using the following process:

```
# docker login
# docker pull docker.io/anchore/enterprise-ui:latest
# docker create --name aui docker.io/anchore/enterprise-ui:latest
# docker cp aui:/config/config-ui.yaml /tmp/my-config-ui.yaml
# docker rm aui
# cat /tmp/my-config-ui.yaml
...
...

```