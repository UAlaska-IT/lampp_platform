# frozen_string_literal: true

tcb = 'mediawiki_application'

directory node[tcb]['database']['backup']['directory'] do
  owner 'root'
  group 'root'
  mode 0o750
end

template File.join('/etc/cron.', node[tcb]['database']['backup']['frequency'], '/mediawiki_backup.sh') do
  source 'backup_script.sh.erb'
  variables(
    db_password: vault_secret_hash(node[tcb]['database']['user_pw'])
  )
  owner 'root'
  group 'root'
  mode 0o750
end
