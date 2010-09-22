#!/usr/bin/env ruby
source      "http://rubygems.org"

DATAMAPPER = 'git://github.com/datamapper'
DATAMAPPER_VERSION = "1.0"

gem "dm-core",              DATAMAPPER_VERSION
gem "dm-is-list",           DATAMAPPER_VERSION
gem "dm-migrations",        DATAMAPPER_VERSION
gem "dm-persevere-adapter", "0.72.0", :require => nil
gem "dm-rest-adapter"

# These are required so we can make it simple to interact with legacy data
gem 'dm-sqlite-adapter',    DATAMAPPER_VERSION, :require => nil
# gem "do_postgres",                            :require => nil

# 1.0 Release of dm-types has problems with UUID properties, use git master
gem "dm-types",       "~> 1.0.0",     :git => "#{DATAMAPPER}/dm-types.git",
                                      :ref => "674738f2a94788b975e9",
                                      :require => false # don't require dm-type/json

# gem 'yogo-project', :git => 'git://github.com/yogo/yogo-project.git', :branch => "topic/contexts", :require  => 'yogo/project'
gem 'yogo-project', :git => 'git://github.com/yogo/yogo-project.git', :branch => "topic/managers", :require  => 'yogo/project'

gem "rails",                "2.3.8"
gem "rake",                 :require => nil

gem 'inherited_resources', '~> 1.0.6'

# Extra supporting gems
gem "carrierwave"
gem "compass"
gem 'bcrypt-ruby'
gem "haml"
gem "mime-types",                     :require => 'mime/types'
gem "uuidtools"
gem 'rails_warden'

gem "mongrel", "1.2.0.pre2"
gem "mongrel_cluster"

platforms(:ruby_18, :jruby) { gem "fastercsv" }

platforms :jruby do
  gem "jruby-openssl",        :require => nil
  gem "json_pure",            :require => nil
  gem "BlueCloth",            :require => nil # Required for YARD
end

platforms :mri do
  gem "json",                 :require => nil
  gem "bluecloth",            :require => nil # Required for YARD
end


group :development do
  gem "capistrano",           :require => nil
  gem "rails-footnotes"
  # Platforms only works in block format in bundler 1.0.0.rc.6
  platforms(:mri_18) { gem "ruby-debug",             :require => nil }
  platforms(:mri_19) { gem "ruby-debug19",           :require => nil }
  gem "test-unit", "1.2.3"
end

group :test, :cucumber do
  # Platforms only works in block format in bundler 1.0.0.rc.6
  platforms(:mri_18) { gem "ruby-debug",             :require => nil }
  platforms(:mri_19) { gem "ruby-debug19",           :require => nil }
  gem 'rspec',        '~>1.3.0',   :require => nil
  gem 'rspec-rails',  '~>1.3.2',   :require => 'spec/rails'
  gem 'ZenTest',                   :require => nil
  gem 'redgreen',                  :require => nil
  gem "yard",                      :require => nil
  gem "yardstick",                 :require => nil
  gem "hoe",                       :require => nil
  gem "ruby_parser",               :require => nil
  gem "flay",                      :require => nil
  gem "flog",                      :require => nil
  gem "chronic",                   :require => nil
  gem "fattr",                     :require => nil
  gem "arrayfields",               :require => nil
  gem "main",                      :require => nil
  gem "hirb",                      :require => nil
  gem "churn",                     :require => nil
  gem "Saikuro",                   :require => nil
  gem "reek",                      :require => nil
  gem "ruby2ruby",                 :require => nil
  gem "roodi",                     :require => nil
  gem "googlecharts",              :require => nil
  gem "metric_fu",                 :require => nil
  gem 'cucumber',                  :require => nil
  gem 'cucumber-rails',            :require => nil
  gem 'webrat',                    :require => nil
  gem 'selenium-client',           :require => nil
end
