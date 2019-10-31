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

    def time_file(db_name, time_stamp)
      return "backup_#{db_name}_#{time_stamp}.sql"
    end

    def latest_file(db_name)
      return "backup_#{db_name}_latest.sql"
    end

    def compress_file(file_name)
      return "#{file_name}.z7"
    end

    def time_path(backup_dir, db_name, time_stamp)
      return "'#{File.join(backup_dir, time_file(db_name, time_stamp))}'"
    end

    def latest_path(backup_dir, db_name)
      return "'#{File.join(backup_dir, latest_file(db_name))}'"
    end

    def compress_path(backup_dir, file_name)
      return "'#{File.join(backup_dir, compress_file(file_name))}'"
    end

    def compress_command(backup_dir, db_name, time_stamp)
      time_file = time_file(db_name, time_stamp)
      return "\np7z a #{compress_path(backup_dir, time_file)} #{time_path(backup_dir, db_name, time_stamp)}"
    end

    def copy_command(backup_dir, db_name, time_stamp)
      return "\ncp #{time_path(backup_dir, db_name, time_stamp)} #{latest_path(backup_dir, db_name)}"
    end

    def s3_path(file)
      s3 = "s3://#{node[TCB]['database']['backup']['s3_path']}"
      s3 += '/' unless s3.match?(%r{/$})
      s3 += file
      return s3
    end

    def s3_copy_command(backup_dir, db_name, time_stamp)
      code = <<~CODE
        \n# Copy both files to S3
        aws s3 cp #{time_path(backup_dir, db_name, time_stamp)} #{s3_path(time_file(db_name, time_stamp))}
        aws s3 cp #{latest_path(backup_dir, db_name)} #{s3_path(latest_file(db_name))}
      CODE
      return code
    end

    def backup_command(backup_dir, db_name, time_stamp)
      code = ''
      code += compress_command(backup_dir, db_name, time_stamp)
      code += copy_command(backup_dir, db_name, time_stamp)
      code += s3_copy_command(backup_dir, db_name, time_stamp) if node[TCB]['database']['backup']['copy_to_s3']
      return code
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
