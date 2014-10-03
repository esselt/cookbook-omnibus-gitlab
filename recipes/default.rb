#
# Cookbook Name:: omnibus-gitlab
# Recipe:: default
#
# Copyright 2014, HiST AITeL
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Install prerequisites
include_recipe 'openssh'
include_recipe 'postfix'

# Download package
filename = ::File.basename(node['omnibusgitlab']['download_url'])
remote_file "#{Chef::Config['file_cache_path']}/#{filename}" do
  source node['omnibusgitlab']['download_url']
  mode 00644
  not_if "test -f #{Chef::Config['file_cache_path']}/#{filename}"
end

# Generate gitlab config file
directory '/etc/gitlab'
template '/etc/gitlab/gitlab.rb' do
  source 'gitlab.erb'
  mode 00600
  variables :config => node['omnibusgitlab']
  notifies :run, 'execute[gitlab-reconfigure]'
end

# Create SSL dir
directory '/etc/gitlab/ssl' do
  mode 00700
end

# Install package
package 'gitlab' do
  source "#{Chef::Config['file_cache_path']}/#{filename}"
  case node['platform_family']
  when 'debian'
    provider Chef::Provider::Package::Dpkg
  when 'rhel'
    provider Chef::Provider::Package::Rpm
  end
  notifies :run, 'execute[gitlab-reconfigure]'
end

# Run reconfigure only on change of config file
execute 'gitlab-reconfigure' do
  command "/opt/gitlab/bin/gitlab-ctl reconfigure"
  action :nothing
  notifies :run, 'execute[gitlab-restart]'
end

# Run restart only after reconfigure
execute 'gitlab-restart' do
  command "/opt/gitlab/bin/gitlab-ctl restart"
  action :nothing
end

# Create repo dir if it does not exist
if node['omnibusgitlab']['repo_dir']
  directory node['omnibusgitlab']['repo_dir'] do
    owner 'git'
    group 'git'
    mode 0755
  end
end

# Set up backup if enabled
cron_d 'gitlab-backup' do
  minute node['omnibusgitlab']['backup_minute']
  hour node['omnibusgitlab']['backup_hour']
  day node['omnibusgitlab']['backup_day']
  month node['omnibusgitlab']['backup_month']
  weekday node['omnibusgitlab']['backup_weekday']

  user 'root'
  command '/opt/gitlab/bin/gitlab-rake gitlab:backup:create > /dev/null'
  mailto node['omnibusgitlab']['backup_email'] if node['omnibusgitlab']['backup_email']

  only_if { node['omnibusgitlab']['backup_enabled'] }
end