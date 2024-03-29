# frozen_string_literal: true

# Compensate for the king-of-snowflakes distro
include_recipe 'yum-epel::default' unless platform_family?('fedora')
include_recipe 'yum-ius::default' unless platform_family?('fedora')

is_debian = platform_family?('debian')

# Not installed on Debian by default
package 'rsync'

# Clean php5
package 'php' do
  action :remove
  not_if { is_debian }
  only_if '[[ $(php --version) =~ "PHP 5" ]]'
end

package 'php-cli' do
  action :remove
  not_if { is_debian }
  only_if '[[ $(php --version) =~ "PHP 5" ]]'
end

package 'php-common' do
  action :remove
  not_if { is_debian }
  only_if '[[ $(php --version) =~ "PHP 5" ]]'
end

# Prerequisites for Linux-Apache2-MySQL-PHP; Command-line debugging
package "#{php_prefix}-#{dev_suffix}"
package "#{php_prefix}-cli"
package "#{php_prefix}-common"

package 'php-mysql' if is_debian
package "#{php_prefix}-mysqlnd" unless is_debian

package "#{php_prefix}-pgsql"

package "#{php_prefix}-json"

package "#{php_prefix}-xml"

# Optimization
package 'php-apcu' if is_debian
package "#{php_prefix}-pecl-apcu" unless is_debian

# Web serving
package "#{php_prefix}-cgi" do
  only_if { install_cgi }
end

package 'libapache2-mod-php' if is_debian
package "mod_#{php_prefix}" unless is_debian

apache2_module 'php7' do
  mod_name php_module_name
end

# The PHP conf is not being enabled on CentOS, then conf.d is deleted by the apache2 cookbook on the next run
[
  'php.conf',
].each do |conf|
  from_path = "file://#{conf_root_directory}/conf.d/#{conf}"
  to_path = File.join(conf_available_directory, conf)

  remote_file to_path do
    source from_path
    owner 'root'
    group 'root'
    mode '644'
    action :nothing
    subscribes :create, 'apache2_module[php7]', :immediate
    notifies :restart, 'service[apache2]', :delayed
    not_if { platform_family?('debian') }
  end

  link File.join(conf_enabled_directory, conf) do
    to to_path
    notifies :restart, 'service[apache2]', :delayed
    not_if { platform_family?('debian') }
  end
end
