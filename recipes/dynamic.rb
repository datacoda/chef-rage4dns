#
# Cookbook Name:: rage4dns
# Recipe:: dynamic
#
# Copyright (C) 2014 Nephila Graphic
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


# Script setup

bin_path = File.join(node['rage4dns']['install_path'], 'bin')
ddrage4client_path = File.join(bin_path, 'ddrage4client')

directory node['rage4dns']['install_path'] do
  user 'root'
  group 'root'
  mode 0755
end

directory bin_path do
  user 'root'
  group 'root'
  mode 0755
end

cookbook_file "ddrage4client" do
  user 'root'
  group 'root'
  mode 0754
  path ddrage4client_path
end

link '/usr/sbin/ddrage4client' do
  to ddrage4client_path
end


# Configuration file

directory node['rage4dns']['config_path'] do
  user 'root'
  group 'root'
  mode 0600
end

template File.join(node['rage4dns']['config_path'], 'ddrage4client.conf') do
  source 'ddrage4client.conf.erb'
  user 'root'
  group 'root'
  mode 0600
  variables(
      :records => node['rage4dns']['dynamic']['records']
  )
end


# Crontab
include_recipe 'cron'
cron_d 'ddrage4client' do
  minute  "*/#{node['rage4dns']['dynamic']['refresh_interval']}"
  if node['dev_mode']
    command "#{ddrage4client_path} -n"
  else
    command ddrage4client_path
  end
end
