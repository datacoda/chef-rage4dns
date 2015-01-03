rage4dns cookbook
-----------------
[![Build Status](https://travis-ci.org/dataferret/chef-rage4dns.svg)](https://travis-ci.org/dataferret/chef-rage4dns)

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

### rage4dns_record

```ruby
rage4dns_record 'test-europe' do
  record_name 'test'
  domain 'example.com'

  type 'A'
  value '16.8.4.3'

  rage_access_key_id 'email@example.com'
  rage_secret_access_key '1234abcd'

  geozone 'Europe'

  failover true
  failover_content '127.0.0.11'

  action :create
end
```


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
