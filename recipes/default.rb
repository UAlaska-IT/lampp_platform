# frozen_string_literal: true

tcb = 'lampp_platform'

include_recipe 'http_platform::default'

include_recipe "#{tcb}::_install"

include_recipe "#{tcb}::_database"

include_recipe "#{tcb}::_app"

include_recipe "#{tcb}::_backup" if node[tcb]['database']['configure_backup']
