# frozen_string_literal: true

tcb = 'lampp_platform'

mariadb_server_install 'Server' do
  password(lazy { vault_default_secret(node[tcb]['database']['root_pw']) }) if node[tcb]['database']['set_root_pw']
end

mariadb_server_configuration 'Configuration'

mariadb_client_install 'Client'

db_name = node[tcb]['database']['db_name']

mariadb_database db_name

user = node[tcb]['database']['user_name']
user_pw = vault_default_secret(node[tcb]['database']['user_pw'])

mariadb_user 'DB User' do
  username user
  password user_pw
end

mariadb_user 'DB Permissions' do
  username user
  password user_pw
  table '*'
  database_name db_name
  privileges [:all]
  action :grant
end
