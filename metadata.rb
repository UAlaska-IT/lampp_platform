# frozen_string_literal: true

name 'lampp_platform'
maintainer 'OIT Systems Engineering'
maintainer_email 'ua-oit-se@alaska.edu'
license 'MIT'
description 'Installs/configures a web platform with Apache, PHP, and MySQL or PostgreSQL'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))

git_url = 'https://github.alaska.edu/oit-cookbooks/lampp_platform'
source_url git_url if respond_to?(:source_url)
issues_url "#{git_url}/issues" if respond_to?(:issues_url)

version '0.1.0'

supports 'ubuntu', '>= 16.0'
supports 'centos', '>= 7.0'

chef_version '>= 14.0' if respond_to?(:chef_version)

depends 'http_platform'
depends 'firewall'
