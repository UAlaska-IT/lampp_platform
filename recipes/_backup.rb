# frozen_string_literal: true

tcb = 'lampp_platform'

backup_dir = default_backup_directory

directory backup_dir do
  owner 'root'
  group 'root'
  mode 0o750
end

host = node[tcb]['database']['host']
user = node[tcb]['database']['user_name']
pass = vault_secret_hash(node[tcb]['database']['user_pw'])
database = node['lampp_platform']['database']['db_name']
time_stamp = Time.now.strftime('%Y-%m-%d')
time_file = "backup_#{time_stamp}.sql"
time_file = "'#{File.join(backup_dir, time_file)}'"
latest_file = "'#{File.join(backup_dir, 'backup_latest.sql')}'"

code = ''
if node[tcb]['database']['configure_mariadb']
  code += "\nmysqldump -h #{host} -u #{user} -p'#{pass}' #{database} -c > #{time_file}"
end

if node[tcb]['database']['configure_postgresql']
  code += "\nPGPASSWORD='#{pass}' pg_dump -U #{user} -h #{host} #{database} > #{time_file}"
end

code += "\ncp #{time_file} #{latest_file}"

if node['lampp_platform']['database']['backup_to_s3']
  code += <<~CODE
    \n# Copy both files to S3
    aws s3 cp #{time_file}
    aws s3 cp #{latest_file}
  CODE
end

cron_d 'lampp_backup' do
  command code
  shell '/bin/bash'
  weekday node[tcb]['database']['backup']['weekday']
  day node[tcb]['database']['backup']['day']
  hour node[tcb]['database']['backup']['hour']
end
