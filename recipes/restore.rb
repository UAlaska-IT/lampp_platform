# frozen_string_literal: true

tcb = 'lampp_platform'

backup_file = File.join(node[tcb]['database']['backup']['_directory'], '/backup_latest.sql')

user = node[tcb]['database']['user_name']
pass = vault_secret_hash(node[tcb]['database']['user_pw'])

bash 'Restore Database' do
  cwd default_backup_directory
  only_if { File.exist?(backup_file) }
  code "mysql -u #{user} -p'#{pass}' #{node[tcb]['database']['db_name']} < #{backup_file}"
end
