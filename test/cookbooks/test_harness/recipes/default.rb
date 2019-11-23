# frozen_string_literal: true

tcb = 'lampp_platform'

# Test lazy logic
node.default[tcb]['app']['archive']['download_base_url'] = 'https://github.com/bcit-ci/CodeIgniter/archive'
node.default[tcb]['app']['archive']['download_file_link'] = '3.1.11.zip'
node.default[tcb]['app']['archive']['download_file_name'] = 'CodeIgniter-3.1.11.zip'
node.default[tcb]['app']['archive']['extract_root_directory'] = 'CodeIgniter-3.1.11'
node.default[tcb]['app']['archive']['extract_creates_file'] = 'index.php'

include_recipe 'lampp_platform::default'
