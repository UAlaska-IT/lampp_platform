# frozen_string_literal: true

tcb = 'lampp_platform'

bash 'Public Hostname' do
  code 'hostnamectl set-hostname `curl -s http://169.254.169.254/latest/meta-data/public-hostname`'
end

node.default[tcb]['app']['archive']['download_base_url'] = 'https://cdn.io.alaska.edu/applications'
node.default[tcb]['app']['archive']['download_file_name'] = 'phpldapadmin-1.2.3.tgz'
node.default[tcb]['app']['archive']['extract_root_directory'] = 'phpldapadmin-1.2.3'
node.default[tcb]['app']['archive']['extract_creates_file'] = 'index.php'

include_recipe 'lampp_platform::default'
