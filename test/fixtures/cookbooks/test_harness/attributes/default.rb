# frozen_string_literal: true

tcb = 'lampp_platform'

default[tcb]['base_name'] = 'codeigniter'

default[tcb]['app']['serve_path'] = 'code'

default[tcb]['database']['db_name'] = 'not_used'
default[tcb]['database']['user_name'] = 'bud'

default[tcb]['database']['root_pw']['vault_bag_item'] = 'lampp'
default[tcb]['database']['user_pw']['vault_bag_item'] = 'lampp'
