# frozen_string_literal: true

module LamppPlatform
  # This module implements shared utility code for consistency with dependent cookbooks
  module Helper
    TCB = 'lampp_platform'

    def lamp_local_database?
      return node[TCB]['database_host'] == 'localhost'
    end

    def php_prefix
      return 'php' if platform_family?('debian') || platform_family?('fedora')

      return "php#{node[TCB]['install']['rhel_php_version'].delete('.')}"
    end

    def dev_suffix
      return 'dev' if platform_family?('debian')

      return 'devel'
    end

    def php_module_name
      return "libphp#{node[TCB]['install']['debian_php_version']}.so" if platform_family?('debian')

      return 'libphp7.so'
    end

    def php_version
      return node[TCB]['install']['debian_php_version'] if platform_family?('debian')

      return node[TCB]['install']['rhel_php_version']
    end

    def install_cgi
      return php_version.to_f < 7.3
    end

    def download_file_link
      link = node[TCB]['app']['archive']['download_file_link']
      return link if link

      return node[TCB]['app']['archive']['download_file_name']
    end

    def download_url
      url = node[TCB]['app']['archive']['download_base_url']
      url += '/' unless url.match?(%r{/$})
      url += download_file_link
      return url
    end

    def lampp_cache_directory
      return File.join('/var/chef/cache', node[TCB]['base_name'])
    end

    def path_to_download
      return File.join(lampp_cache_directory, node[TCB]['app']['archive']['download_file_name'])
    end

    def path_to_source
      return File.join(lampp_cache_directory, node[TCB]['app']['archive']['extract_root_directory'])
    end

    def path_to_extract_file
      return File.join(path_to_source, node[TCB]['app']['archive']['extract_creates_file'])
    end

    def lampp_lib_location
      return File.join('/var/lib', node[TCB]['base_name'])
    end

    def serve_path
      return File.join('/var/www/html', node[TCB]['app']['serve_path'])
    end

    def lampp_sync_command
      # Rsync regularizes the lib directory and ensure no files hang around from old versions
      code = 'rsync -av --delete-before'
      node[TCB]['app']['sync']['exclude_paths'].each do |path|
        code += " --exclude '#{path}'"
      end
      # Note the trailing slashes
      code += " '#{path_to_source}/' '#{lampp_lib_location}/'"
    end

    def vault_secret(bag, item, key)
      # Will raise 404 error if not found
      item = chef_vault_item(
        bag,
        item
      )
      raise 'Unable to retrieve vault item' if item.nil?

      secret = item[key]
      raise 'Unable to retrieve item key' if secret.nil?

      return secret
    end

    def vault_secret_hash(object)
      return vault_secret(object['vault_data_bag'], object['vault_bag_item'], object['vault_item_key'])
    end

    def default_bag_item(object)
      attr = object['vault_bag_item']
      return attr if attr

      return node[TCB]['base_name']
    end

    def vault_default_secret(object)
      return vault_secret(object['vault_data_bag'], default_bag_item(object), object['vault_item_key'])
    end
  end
end

Chef::Provider.include(LamppPlatform::Helper)
Chef::Recipe.include(LamppPlatform::Helper)
Chef::Resource.include(LamppPlatform::Helper)
