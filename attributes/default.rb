# frozen_string_literal: true

tcb = 'lampp_platform'

# mod_php does not support threading
default['http_platform']['apache']['mpm_module'] = 'prefork'

default[tcb]['database_host'] = 'localhost'

default[tcb]['base_name'] = nil
