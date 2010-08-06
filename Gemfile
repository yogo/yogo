#!/usr/bin/env ruby
source      "http://rubygems.org"

DATAMAPPER = 'git://github.com/datamapper'

gem "dm-core",              "1.0"

# gem "dm-timestamps",        "1.0"
# gem "dm-validations",       "1.0"
# gem "dm-is-nested_set",     "1.0"
# # gem "dm-serializer",        "1.0"
# gem "dm-aggregates",        "1.0"
gem "dm-migrations"
# gem "dm-types",              "1.0",     :git => "#{DATAMAPPER}/dm-types.git",
#                                         :require => false
# gem "dm-observer",          "1.0"
# gem "dm-persevere-adapter", "0.72.0", :require => nil
# gem "rails_datamapper", :require => nil #,     "1.0" #, :require => nil



# These are required so we can make it simple to interact with legacy data
#gem "do_mysql",                       :require => nil
#gem "do_postgres",                   :require => nil
# gem "do_sqlite3",                    :require => nil
gem 'dm-sqlite-adapter', :require => nil
#gem "do_sqlserver",                  :require => nil

gem 'yogo-project', :git => 'git://github.com/yogo/yogo-project.git', :require  => 'yogo/project'

gem "rails",                "2.3.8"
gem "rake",                          :require => nil

gem 'inherited_resources', '~> 1.0.6'

# Extra supporting gems
gem "carrierwave"
gem "compass"
gem 'bcrypt-ruby'
gem "fastercsv"                       unless RUBY_VERSION >= '1.9.1'
gem "haml"
gem "mime-types",                     :require => 'mime/types'
gem "uuidtools"

gem 'rails_warden'

if defined?(JRUBY_VERSION)
  gem "json_pure",            :require => nil
  gem "BlueCloth",            :require => nil # Required for YARD
else
  gem "json",                 :require => nil
  gem "bluecloth",            :require => nil # Required for YARD
end

gem RUBY_VERSION.include?('1.9') ? 'ruby-debug19' : 'ruby-debug', :require => nil, :group => :development unless defined?(JRUBY_VERSION)

gem "rails-footnotes",             :group => :development

group :test do
gem RUBY_VERSION.include?('1.9') ? 'ruby-debug19' : 'ruby-debug',       :require => nil unless defined?(JRUBY_VERSION)
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
  gem "test-unit", "~>1.2" if RUBY_VERSION.include?('1.9')
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
gem 'mongrel',                     :require => nil unless RUBY_VERSION >= '1.9.1'
gem 'thin',                        :require => nil unless defined?(JRUBY_VERSION)

