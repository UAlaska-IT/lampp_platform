# frozen_string_literal: true

name 'test_harness'
maintainer 'OIT Systems Engineering'
maintainer_email 'ua-oit-se@alaska.edu'
license 'MIT'
description 'Test fixture for the lampp_platform cookbook'

git_url = 'https://github.com/ualaska-it/lampp_platform'
source_url git_url
issues_url "#{git_url}/issues"

version '1.0.0'

supports 'ubuntu', '>= 16.0'
supports 'centos', '>= 7.0'

chef_version '>= 14.0.0' if respond_to?(:chef_version)

depends 'lampp_platform'
