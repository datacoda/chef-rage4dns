#
# Cookbook Name:: rage4dns
# Provider:: record
#
# Copyright (C) 2015 Nephila Graphic
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

action :create do
  api = Rage4::API.new @new_resource.rage_access_key_id, @new_resource.rage_secret_access_key
  changed = api.create @new_resource.domain,
                       type: @new_resource.type,
                       name: @new_resource.record_name + '.' + @new_resource.domain,
                       content: @new_resource.value,
                       ttl: @new_resource.ttl,
                       geozone: @new_resource.geozone,
                       failover: @new_resource.failover,
                       failover_content: @new_resource.failover_content

  new_resource.updated_by_last_action(changed)
end

action :delete do
  api = Rage4::API.new @new_resource.rage_access_key_id, @new_resource.rage_secret_access_key
  changed = api.delete @new_resource.domain,
                       type: @new_resource.type,
                       name: @new_resource.record_name + '.' + @new_resource.domain,
                       content: @new_resource.value,
                       geozone: @new_resource.geozone

  new_resource.updated_by_last_action(changed)
end
