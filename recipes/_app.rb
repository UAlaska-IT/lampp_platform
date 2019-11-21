# frozen_string_literal: true

tcb = 'lampp_platform'

Chef::Resource.include(Apache2::Cookbook::Helpers)

cookbook_file '/var/www/html/phpinfo.php' do
  source 'phpinfo.php'
  owner default_apache_user
  group default_apache_group
  mode '755'
  action :create
  only_if { node[tcb]['create_php_info'] }
end

directory lampp_cache_directory do
  owner 'root'
  group 'root'
  mode '755'
  recursive true
end

remote_file 'Archive DL' do
  path(lazy { path_to_download })
  source(lazy { download_url })
  owner 'root'
  group 'root'
  mode '755'
end

serve_location = lampp_lib_location
directory serve_location do
  owner default_apache_user
  group default_apache_group
  mode '755'
end

link 'App Link' do
  target_file(lazy { serve_path })
  to serve_location
  owner default_apache_user
  group default_apache_group
end

checksum_file 'Archive Checksum' do
  source_path(lazy { path_to_download })
  target_path "#{lampp_cache_directory}/#{node[tcb]['base_name']}-dl-checksum"
end

ruby_block 'App Updated' do
  block do
    node.default[tcb]['app_updated'] = true
  end
  action :nothing
  subscribes :run, 'checksum_file[Archive Checksum]', :immediate
end

# Extraction is not idempotent?
archive_file 'Application Archive' do
  path(lazy { path_to_download })
  destination lampp_cache_directory
  overwrite true
  group 'root'
  owner 'root'
  only_if { node[tcb]['app_updated'] || !File.exist?(path_to_extract_file) }
end

bash 'Sync Files' do
  code(lazy { lampp_sync_command })
  only_if { node[tcb]['app_updated'] }
end

bash 'Set Permissions' do
  code "chown -R #{default_apache_user}:#{default_apache_group} '#{serve_location}'"
  only_if { node[tcb]['app_updated'] }
end
