# frozen_string_literal: true

source 'https://supermarket.chef.io'

metadata

cookbook 'se_baseline', git: 'git@github.alaska.edu:oit-cookbooks/http_platform'

group :test do
  cookbook 'se_baseline', git: 'git@github.alaska.edu:oit-cookbooks/se_baseline'
  cookbook 'se-nix-baseline', git: 'git@github.alaska.edu:oit-cookbooks/se-nix-baseline'
  cookbook 'sensu_client', git: 'git@github.alaska.edu:oit-cookbooks/sensu_client'
end