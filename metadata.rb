# frozen_string_literal: true

name 'lampp_platform'
maintainer 'OIT Systems Engineering'
maintainer_email 'ua-oit-se@alaska.edu'
license 'MIT'
description 'Installs/configures a web platform with Apache, PHP, and MariaDB or PostgreSQL'

git_url = 'https://github.com/UAlaska-IT/lampp_platform'
source_url git_url
issues_url "#{git_url}/issues"

version '0.1.0'

supports 'ubuntu', '>= 18.0'
supports 'centos', '>= 7.0'

chef_version '>= 14.0' if respond_to?(:chef_version)

depends 'checksum_file'
depends 'chef_run_recorder'
depends 'http_platform'
depends 'mariadb'
depends 'yum-epel'
depends 'yum-ius'
