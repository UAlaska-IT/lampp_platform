# frozen_string_literal: true

require_relative '../helpers'

node = json('/opt/chef/run_record/last_chef_run_node.json')['automatic']

# Make sure the end result is a working server

describe service(apache_service(node)) do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe bash('apachectl configtest') do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should match 'Syntax OK' } # Yep, output is on stderr
  its(:stdout) { should eq '' }
end

pages = [
  {
    page: '',
    status: 200,
    content: %r{Index of /},
  },
  {
    page: '/code/index.php',
    status: 200,
    content: /Welcome to CodeIgniter!/,
  },
  {
    page: '/phpinfo.php',
    status: 200,
    content: /PHP Version 7\.2/,
  },
]

pages.each do |page|
  describe http("https://localhost#{page[:page]}", ssl_verify: false) do
    its(:status) { should cmp page[:status] }
    its(:body) { should match(page[:content]) }
  end
end
