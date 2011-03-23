
#
# Cookbook Name:: rvm
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "curl"
package "git-core"
package "build-essential"

rvm_dev_packages = ['libreadline5-dev',
                    'zlib1g-dev',
                    'libssl-dev',
                    'libxml2-dev',
                    'libxslt1-dev']

rvm_dev_packages.each {|p| package p}

# Install RVM
bash "install RVM" do
  user "root"
  code "bash < <( curl -L http://bit.ly/rvm-install-system-wide )"
  not_if "which rvm && rvm --version"
end

cookbook_file "/etc/profile.d/rvm.sh" do
  mode 0644
  owner "root"
  group "root"
end

# Set default RVM Ruby
bash "install default RVM ruby" do
  user "root"
  code "rvm install 1.8.7"
  not_if "rvm list | grep 1.9.2"
end

bash "make 1.8.7 the default RVM ruby" do
  user "root"
  code "rvm --default 1.8.7"
end

bash "install RVM ruby 1.9.2" do
  user "root"
  code "rvm install 1.9.2"
  not_if "rvm list | grep 1.9.2"
end

# ruby-debug19 is a pain to install under rvm
bash "install ruby-debug19 under rvm" do
  user "root"
  code 'rvm 1.9.2 gem install ruby-debug19 -- --with-ruby-include="$rvm_src_path/$(rvm tools identifier)/"'
  not_if "rvm 1.9.2 gem list | grep ruby-debug19"
end

# Ensure chef is installed in default rvm ruby
gem_package "chef" do
  gem_binary "rvm 1.8.7 gem"
  only_if "test -e /usr/local/bin/rvm"
end


