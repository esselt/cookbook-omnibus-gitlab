name             'omnibus-gitlab'
maintainer       'Boye Holden'
maintainer_email 'boye.holden@hist.no'
license          'Apache 2.0'
description      'Installs/Configures GitLab with the omnibus package'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '7.3.2'

%w(openssh postfix cron).each do |pkg|
  depends pkg
end

supports 'ubuntu', '= 12.04'
supports 'ubuntu', '= 14.04'
supports 'debian', '~> 7.0'