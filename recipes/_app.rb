# frozen_string_literal: true

tcb = 'mediawiki_application'

Chef::Resource.include(Apache2::Cookbook::Helpers)

cookbook_file '/var/www/html/phpinfo.php' do
  source 'phpinfo.php'
  owner default_apache_user
  group default_apache_group
  mode 0o755
  action :create
  only_if { node[tcb]['create_php_info'] }
end

cache_dir = '/var/chef/cache/mediawiki'

directory cache_dir do
  owner 'root'
  group 'root'
  mode 0o755
  recursive true
end

dl_location = "#{cache_dir}/#{mediawiki_directory}.tag.gz"

remote_file 'MediaWiki DL' do
  path dl_location
  source mediawiki_url
  owner 'root'
  group 'root'
  mode 0o755
end

serve_location = '/var/lib/mediawiki'
directory serve_location do
  owner 'root'
  group 'root'
  mode 0o755
end

link "/var/www/html#{node[tcb]['wiki']['script_path']}" do
  to serve_location
  owner default_apache_user
  group default_apache_group
end

checksum_file 'Mediawiki Checksum' do
  source_path dl_location
  target_path "#{cache_dir}/#{mediawiki_directory}-dl-checksum"
end
# Extraction is not idempotent?
archive_file 'Mediawiki Archive' do
  path dl_location
  destination cache_dir
  overwrite true
  group 'root'
  owner 'root'
  action :nothing
  subscribes :extract, 'checksum_file[Mediawiki Checksum]', :immediate
end
# Rsync regularizes the lib directory and ensure no files hang around from old versions
# Note the trailing slashes
src_location = File.join(cache_dir, mediawiki_directory)
bash 'Sync Files' do
  code "rsync -av --delete-before --exclude 'LocalSettings.php' '#{src_location}/' '#{serve_location}/'"
  action :nothing
  subscribes :run, 'archive_file[Mediawiki Archive]', :immediate
end
bash 'Set Permissions' do
  code "chown -R #{default_apache_user}:#{default_apache_group} '#{serve_location}'"
  action :nothing
  subscribes :run, 'bash[Sync Files]', :immediate
end
