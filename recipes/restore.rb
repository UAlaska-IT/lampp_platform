# frozen_string_literal: true

tcb = 'lampp_platform'

host = node[tcb]['database']['host']
user = node[tcb]['database']['user_name']
pass = vault_secret_hash(node[tcb]['database']['user_pw'])
database = node['lampp_platform']['database']['db_name']

code = ''
if node[tcb]['database']['configure_mariadb'] && File.exist?(compress_path(latest_path('mariadb')))
  code += extract_command('mariadb')
  code += "\nmysql -u #{user} -p'#{pass}' #{database} < #{latest_path('mariadb')}"
  code += extract_delete_command('mariadb')
end

if node[tcb]['database']['configure_postgresql'] && File.exist?(compress_path(latest_path('postgresql')))
  code += extract_command('postgresql')
  code += "\nPGPASSWORD='#{pass}' psql -h #{host} -U #{user} #{database} < #{latest_path('postgresql')}"
  code += extract_delete_command('postgresql')
end

bash 'Restore Database' do
  code code
  cwd default_backup_directory
end
