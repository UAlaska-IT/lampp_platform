# frozen_string_literal: true

name 'lampp_platform'
maintainer 'OIT Systems Engineering'
maintainer_email 'ua-oit-se@alaska.edu'
license 'MIT'
description 'Configures a web platform with Apache, PHP, and MariaDB or PostgreSQL'

git_url = 'https://github.com/UAlaska-IT/lampp_platform'
source_url git_url
issues_url "#{git_url}/issues"

version '0.1.0'

supports 'ubuntu', '>= 16.0'
supports 'debian', '>= 9.0'
supports 'redhat', '>= 7.0'
supports 'centos', '>= 7.0'
supports 'oracle', '>= 7.0'
supports 'fedora'
# supports 'amazon'
# supports 'suse'
# supports 'opensuse'

chef_version '>= 14.0'

depends 'checksum_file'
depends 'chef_run_recorder'
depends 'database_application'
depends 'http_platform'
depends 'yum-epel'
depends 'yum-ius'
