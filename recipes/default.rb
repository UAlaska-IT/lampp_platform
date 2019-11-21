# frozen_string_literal: true

tcb = 'lampp_platform'

include_recipe 'http_platform::default'

include_recipe 'database_application::server' if node[tcb]['configure_local_database']

include_recipe 'database_application::client'

include_recipe "#{tcb}::_install"

include_recipe "#{tcb}::_app"
