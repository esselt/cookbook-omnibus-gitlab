#
# Cookbook Name:: omnibus-gitlab
# Attribute:: default
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

case node['platform']
when 'ubuntu'
  if node['platform_version'] == '12.04'
    default['omnibusgitlab']['download_url']  = 'https://downloads-packages.s3.amazonaws.com/ubuntu-12.04/gitlab_7.6.2-omnibus.5.3.0.ci.1-1_amd64.deb'
  elsif node['platform_version'] == '14.04'
    default['omnibusgitlab']['download_url']  = 'https://downloads-packages.s3.amazonaws.com/ubuntu-14.04/gitlab_7.6.2-omnibus.5.3.0.ci.1-1_amd64.deb'
  end
when 'debian'
  default['omnibusgitlab']['download_url']    = 'https://downloads-packages.s3.amazonaws.com/debian-7.7/gitlab_7.6.2-omnibus.5.3.0.ci.1-1_amd64.deb'
end

default['omnibusgitlab']['site_url']          = node['fqdn']
default['omnibusgitlab']['repo_dir']          = nil
default['omnibusgitlab']['from_email']        = "gitlab@#{node['fqdn']}"
default['omnibusgitlab']['support_email']     = "gitlab@#{node['fqdn']}"

default['omnibusgitlab']['user_can_create_groups'] = true

default['omnibusgitlab']['ldap_enabled']      = false
default['omnibusgitlab']['ldap_is_ad']        = true
default['omnibusgitlab']['ldap_host']         = nil
default['omnibusgitlab']['ldap_port']         = nil
default['omnibusgitlab']['ldap_uid']          = nil
default['omnibusgitlab']['ldap_method']       = nil
default['omnibusgitlab']['ldap_bind_dn']      = nil
default['omnibusgitlab']['ldap_password']     = nil
default['omnibusgitlab']['ldap_allow_username_or_email_login'] = true
default['omnibusgitlab']['ldap_base']         = nil

default['omnibusgitlab']['ssl_enabled']       = false

default['omnibusgitlab']['backup_enabled']    = false
default['omnibusgitlab']['backup_path']       = nil
default['omnibusgitlab']['backup_minute']     = 15
default['omnibusgitlab']['backup_hour']       = 3
default['omnibusgitlab']['backup_day']        = '*'
default['omnibusgitlab']['backup_month']      = '*'
default['omnibusgitlab']['backup_weekday']    = '*'
default['omnibusgitlab']['backup_email']      = nil