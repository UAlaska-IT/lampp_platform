# frozen_string_literal: true

tcb = 'lampp_platform'

mariadb_server_install 'Server' do
  password(lazy { vault_default_secret(node[tcb]['database']['root_pw']) }) if node[tcb]['database']['set_root_pw']
  only_if { node[tcb]['database']['configure_mariadb'] }
end

mariadb_server_configuration 'Configuration' do
  only_if { node[tcb]['database']['configure_mariadb'] }
end

mariadb_client_install 'Client' do
  only_if { node[tcb]['database']['configure_mariadb'] }
end

db_name = node[tcb]['database']['db_name']

mariadb_database db_name do
  only_if { node[tcb]['database']['configure_mariadb'] }
end

user = node[tcb]['database']['user_name']
user_pw = vault_default_secret(node[tcb]['database']['user_pw'])

mariadb_user 'DB User' do
  username user
  password user_pw
  only_if { node[tcb]['database']['configure_mariadb'] }
end

mariadb_user 'DB Permissions' do
  username user
  password user_pw
  table '*'
  database_name db_name
  privileges [:all]
  action :grant
  only_if { node[tcb]['database']['configure_mariadb'] }
end
