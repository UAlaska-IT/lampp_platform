# frozen_string_literal: true

def apache_user(node)
  return 'www-data' if node['platform_family'] == 'debian'

  return 'apache'
end

def apache_group(node)
  return 'www-data' if node['platform_family'] == 'debian'

  return 'apache'
end

def apache_service(node)
  return 'apache2' if node['platform_family'] == 'debian'

  return 'httpd'
end

def php_prefix(node)
  return 'php' unless node['platform_family'] == 'rhel'

  return 'php73'
end

def installed_command(node)
  return 'apt list --installed' if node['platform_family'] == 'debian'

  return 'yum list installed'
end

def install_cgi(node)
  return node['platform_family'] == 'debian'
end

def dev_suffix(node)
  return 'dev' if node['platform_family'] == 'debian'

  return 'devel'
end
