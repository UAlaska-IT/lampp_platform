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

    def default_backup_directory
      dir = node[TCB]['database']['backup']['directory']
      return dir if dir

      return File.join('/var/backups', node[TCB]['app_name'])
    end

    def mediawiki_directory
      return "mediawiki-#{node[TCB]['wiki']['release_version']}.#{node[TCB]['wiki']['patch_version']}"
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

      return node[TCB]['app_name']
    end

    def vault_default_secret(object)
      return vault_secret(object['vault_data_bag'], default_bag_item(object), object['vault_item_key'])
    end
  end
end

Chef::Provider.include(LamppPlatform::Helper)
Chef::Recipe.include(LamppPlatform::Helper)
Chef::Resource.include(LamppPlatform::Helper)
