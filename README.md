rage4dns cookbook
-----------------
This cookbook provides libraries, resources and providers to configure and manage Rage4 DNS

Tested on

* Ubuntu 12.04

Untested (but likely works) on

* Debian

Probably needs some more work on

* Centos


Requirements
------------
Python 2.7, installed

A Rage4 DNS account is required.  For client-side dynamic DNS updates, the record api needs to be pre-generated.

Usage
-----

Attributes
----------

- `['rage4dns']['install_path']` - default '/opt/rage4dns'
- `['rage4dns']['config_path']` - default '/etc/rage4dns'
- `['rage4dns']['ddrage4client']['path']` - default /opt/range4dns/bin/ddrage4client

- `['rage4dns']['dynamic']['refresh_interval']` Refresh in minutes.  default 10
- `['rage4dns']['dynamic']['records']` Specify name, apikey pairs.  default {}


Recipes
-------

### dynamic
Installs a dynamic DNS updater with cron.  Specify apikeys in `['rage4dns']['dynamic']['records']` attribute.


Resources/Providers
-------------------


License & Authors
-----------------
- Author:: Ted Chen (<ted@nephilagraphic.com>)

```text
Copyright 2014, Nephila Graphic

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```