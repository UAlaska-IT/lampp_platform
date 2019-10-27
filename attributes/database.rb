# frozen_string_literal: true

tcb = 'lampp_platform'

default[tcb]['database']['host'] = 'localhost'
default[tcb]['database']['db_name'] = 'wiki'
default[tcb]['database']['user_name'] = 'wiki_user'

default[tcb]['database']['set_root_pw'] = true
default[tcb]['database']['root_pw']['vault_data_bag'] = 'passwords'
default[tcb]['database']['root_pw']['vault_bag_item'] = nil
default[tcb]['database']['root_pw']['vault_item_key'] = 'db_root'

default[tcb]['database']['user_pw']['vault_data_bag'] = 'passwords'
default[tcb]['database']['user_pw']['vault_bag_item'] = nil
default[tcb]['database']['user_pw']['vault_item_key'] = 'db_user'

default[tcb]['database']['backup']['directory'] = '/var/backups/mediawiki'
default[tcb]['database']['backup']['frequency'] = 'weekly'

default[tcb]['database']['backup']['copy_to_s3'] = false
default[tcb]['database']['backup']['delete_local_copy'] = false
default[tcb]['database']['backup']['s3_location'] = nil
