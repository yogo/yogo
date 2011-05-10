#
# Cookbook Name:: voeis_dev
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Add vagrant user to rvm group
group "rvm" do
  action :modify
  append true
  members ['vagrant']
  only_if 'users | grep -i "vagrant"'
end

# gem_package "bundler" do
#   gem_binary "rvm 1.9.2,1.8.7 gem"
#   only_if "test -e /usr/local/bin/rvm"
# end

gem_package "ruby-debug19" do
  gem_binary "rvm 1.9.2 gem"
  only_if "test -e /usr/local/bin/rvm"
  options '-- --with-ruby-include="$rvm_src_path/$(rvm tools identifier)/"'
end

require_recipe "postgresql::server"
package "libpq-dev"
package "sqlite3"
package "libsqlite3-dev"

template "#{node[:postgresql][:dir]}/pg_hba.conf" do
  source "debian.pg_hba.conf.erb"
  owner "postgres"
  group "postgres"
  mode 0600
  notifies :reload, resources(:service => "postgresql")
end

bash "Creating 'vagrant' user for Postgres" do
  user "postgres"
  code "createuser --no-superuser --no-createrole --createdb vagrant || echo 'Vagrant user exists'"
  # not_if "psql -c 'SELECT usename FROM pg_user;' | grep -q vagrant"
end


dev_path = "/vagrant"
bundle_path = "/tmp/voeis_bundle"

# script 'Bundling Gems' do
#   interpreter 'bash'
#   cwd dev_path
#   code <<-CODE
#     bundle install --deployment --path #{bundle_path}
#   CODE
# end

# bash "Bundling Gems" do
#   user "vagrant"
#   code "cd /vagrant && bundle install"
# end

# Packages for doing development in the VM
package "tmux"

