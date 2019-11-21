# frozen_string_literal: true

require_relative '../helpers'

node = json('/opt/chef/run_record/last_chef_run_node.json')['automatic']

# frozen_string_literal: true

version = '3.1.11'
cache_dir = '/var/chef/cache/codeigniter'
serve_dir = '/var/lib/codeigniter'

describe file '/var/www/html/phpinfo.php' do
  it { should exist }
  it { should be_file }
  it { should be_mode 0o755 }
  it { should be_owned_by apache_user(node) }
  it { should be_grouped_into apache_group(node) }
end

describe file cache_dir do
  it { should exist }
  it { should be_directory }
  it { should be_mode 0o755 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file File.join(cache_dir, "CodeIgniter-#{version}.zip") do
  it { should exist }
  it { should be_file }
  it { should be_mode 0o755 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file File.join(cache_dir, "CodeIgniter-#{version}") do
  it { should exist }
  it { should be_directory }
  it { should be_mode 0o755 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file '/var/www/html/code' do
  it { should exist }
  it { should be_symlink }
  it { should be_mode 0o755 }
  # Permissions are for the directory
  it { should be_owned_by apache_user(node) }
  it { should be_grouped_into apache_group(node) }
  its(:link_path) { should eq serve_dir }
end

describe file File.join(cache_dir, "CodeIgniter-#{version}/index.php") do
  it { should exist }
  it { should be_file }
  it { should be_mode 0o755 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file File.join(serve_dir, 'index.php') do
  it { should exist }
  it { should be_file }
  it { should be_mode 0o755 }
  it { should be_owned_by apache_user(node) }
  it { should be_grouped_into apache_group(node) }
end
