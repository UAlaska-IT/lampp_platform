# frozen_string_literal: true

require_relative '../helpers'

node = json('/opt/chef/run_record/last_chef_run_node.json')['automatic']

describe bash('yum repolist') do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq '' }
  its(:stdout) { should match 'epel/x86_64' }
  its(:stdout) { should match 'ius/x86_64' }
  before do
    skip if node['platform_family'] == 'debian'
  end
end

describe bash('php --version') do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq '' }
  its(:stdout) { should_not match(/PHP 5/i) }
end

# Prerequisites for Linux-Apache2-MySQL-PHP; Command-line debugging
describe package php_prefix(node) do
  it { should be_installed }
end

describe package "#{php_prefix(node)}-cli" do
  it { should be_installed }
end

describe package "#{php_prefix(node)}-common" do
  it { should be_installed }
end

describe package 'php-mysql' do
  it { should be_installed }
  before do
    skip unless node['platform_family'] == 'debian'
  end
end

describe package "#{php_prefix(node)}-mysqlnd" do
  it { should be_installed }
  before do
    skip if node['platform_family'] == 'debian'
  end
end

describe package "#{php_prefix(node)}-json" do
  it { should be_installed }
end

describe package "#{php_prefix(node)}-xml" do
  it { should be_installed }
end

describe package "#{php_prefix(node)}-mbstring" do
  it { should be_installed }
end

# Optimization
describe package 'php-apcu' do
  it { should be_installed }
  before do
    skip unless node['platform_family'] == 'debian'
  end
end

describe package "#{php_prefix(node)}-pecl-apcu" do
  it { should be_installed }
  before do
    skip if node['platform_family'] == 'debian'
  end
end

describe package "#{php_prefix(node)}-intl" do
  it { should be_installed }
end

# Images and thumbnails
describe package 'imagemagick' do
  it { should be_installed }
  before do
    skip unless node['platform_family'] == 'debian'
  end
end

describe package 'ImageMagick' do
  it { should be_installed }
  before do
    skip if node['platform_family'] == 'debian'
  end
end

describe package 'inkscape' do
  it { should be_installed }
end

describe package "#{php_prefix(node)}-gd" do
  it { should be_installed }
end

# Web serving
describe package "#{php_prefix(node)}-cgi" do
  it { should be_installed }
end

describe package 'libapache2-mod-php' do
  it { should be_installed }
  before do
    skip unless node['platform_family'] == 'debian'
  end
end

describe package "mod_#{php_prefix(node)}" do
  it { should be_installed }
  before do
    skip if node['platform_family'] == 'debian'
  end
end

apache_lib_dir =
  if node['platform_family'] == 'debian'
    '/usr/lib/apache2/modules'
  else
    '/usr/lib64/httpd/modules'
  end

describe bash("ls #{apache_lib_dir}") do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq '' }
  its(:stdout) { should match 'libphp7' }
end

describe bash('apachectl -M') do
  its(:exit_status) { should eq 0 }
  # its(:stderr) { should eq '' } # Getting redundant loading of php7 and php7.2
  its(:stdout) { should match 'php7' }
end
