# frozen_string_literal: true

# mod_php does not support threading
default['http_platform']['apache']['mpm_module'] = 'prefork'
