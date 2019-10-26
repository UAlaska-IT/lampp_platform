# frozen_string_literal: true

module MediaWiki
  # This module implements shared utility code for consistency with dependent cookbooks
  module Helper
    TCB = 'mediawiki_application'

    def php_prefix
      return 'php' if node['platform_family'] == 'debian'

      return node[TCB]['install']['rhel_centos_version']
    end

    def php_module_name
      return 'libphp7.2.so' if node['platform_family'] == 'debian'

      return 'libphp7.so'
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
  end
end

Chef::Provider.include(MediaWiki::Helper)
Chef::Recipe.include(MediaWiki::Helper)
Chef::Resource.include(MediaWiki::Helper)
