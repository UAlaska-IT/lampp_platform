# frozen_string_literal: true

tcb = 'lampp_platform'

include_recipe 'http_platform::default'

include_recipe "#{tcb}::_install"

include_recipe "#{tcb}::_database"
