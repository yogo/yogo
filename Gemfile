#!/usr/bin/env ruby
source      "http://rubygems.org"

# Required core gems
gem "rails",                "2.3.5", :require => nil
gem "rake",                          :require => nil
gem "dm-core",              "0.10.2"
gem "dm-reflection",        "0.0.1", :path => "vendor/gems/dm-reflection-0.0.1"
gem "dm-timestamps"  
gem "dm-validations"
gem "dm-is-nested_set"
gem "dm-ar-finders"
gem "dm-serializer",        "0.10.2", :path => "vendor/gems/dm-serializer-0.10.2"
gem "dm-aggregates"
gem "dm-types"
gem "dm-persevere-adapter", "0.43.0", :require => nil
gem "do_sqlite3",           "0.10.1", :require => nil
gem "rails_datamapper"

# Extra supporting gems
# gem "authlogic",            "2.1.3"
gem "fastercsv"
gem "carrierwave"

# JRUBY sensitive gems
if defined?(JRUBY_VERSION)
  gem "json_pure",         '~>1.2.0',    :require => nil
  gem "jruby-openssl",                 :require => nil
  # gem "ruby-debug-base",   "0.10.3.1", :require => nil,
  #                                      :path => "vendor/extra_gems/ruby-debug-base-0.10.3.1-java"
  
  # When in "production" we run with jruby, so we include the adapters for other databases.
  #gem "do_mysql",             "0.10.1", :require => nil
  #gem "do_postgres",          "0.10.1", :require => nil
else
  gem "json",      "~>1.2.0", :require => nil
  gem 'ruby-debug',         :require => nil
end

group :test do
  gem 'rspec',        '~>1.3.0',   :require => nil
  gem 'rspec-rails',  '~>1.3.2',   :require => 'spec/rails'
  gem 'ZenTest',                   :require => nil
  gem 'redgreen',                  :require => nil
  gem 'factory_girl', '~>1.2.3',   :require => nil
end

group :cucumber do
  gem 'rspec',        '~>1.3.0',   :require => nil
  gem 'rspec-rails',  '~>1.3.2',   :require => 'spec/rails'
  gem 'ZenTest',                   :require => nil
  gem 'redgreen',                  :require => nil
  gem 'factory_girl', '~>1.2.3',   :require => nil
  gem 'cucumber',                  :require => nil
  gem 'cucumber-rails'
  gem 'webrat',                    :require => nil
  gem 'selenium-client',           :require => nil
end

# A dev server that is slightly better then webrick
gem 'mongrel', :require => nil

