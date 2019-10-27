# frozen_string_literal: true

module LamppPlatform
  # This module implements shared utility code for consistency with dependent cookbooks
  module Helper
    TCB = 'lampp_platform'

    def php_prefix
      return 'php' if node['platform_family'] == 'debian'

      return node[TCB]['install']['rhel_centos_version']
    end

    def php_module_name
      return 'libphp7.2.so' if node['platform_family'] == 'debian'

      return 'libphp7.so'
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

    def cache_directory
      return File.join('/var/chef/cache', node[TCB]['base_name'])
    end

    def path_to_download
      return File.join(cache_directory, node[TCB]['app']['archive']['download_file_name'])
    end

    def path_to_source
      return File.join(cache_directory, node[TCB]['app']['archive']['extract_root_directory'])
    end

    def path_to_extract_file
      return File.join(path_to_source, node[TCB]['app']['archive']['extract_creates_file'])
    end

    def serve_path
      return File.join('/var/www/html', node[TCB]['app']['serve_path'])
    end

    def default_backup_directory
      dir = node[TCB]['database']['backup']['directory']
      return dir if dir

      return File.join('/var/backups', node[TCB]['base_name'])
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
