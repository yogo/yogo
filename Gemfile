#!/usr/bin/env ruby
source      "http://rubygems.org"

# Required core gems
gem "rails",                "2.3.5", :require => nil
gem "rake",                          :require => nil
gem "dm-core",              "0.10.2"

gem "dm-reflection",        "0.10.2", :git => "git://github.com/yogo/dm-reflection.git" # :path => "vendor/gems/dm-reflection-0.0.1"
gem "dm-timestamps" 
gem "dm-validations"
gem "dm-is-nested_set"
gem "dm-serializer",        "0.10.2", :path => "vendor/gems/dm-serializer-0.10.2"
gem "dm-aggregates"
gem "dm-types"
gem "dm-observer"
gem "dm-persevere-adapter", "0.52.1", :require => nil
gem "do_sqlite3",                     :require => nil
gem "rails_datamapper",               :require => nil

# Extra supporting gems
# gem "authlogic",            "2.1.3"
gem "mime-types",                     :require => 'mime/types'
gem "fastercsv"                       # unless RUBY 1.9
gem "carrierwave"
gem "compass"
gem "haml"
gem "uuidtools"


if defined?(JRUBY_VERSION)
  gem "json_pure",            :require => nil
else
  gem "json",                 :require => nil  
end


gem 'ruby-debug',                  :group => :development unless defined?(JRUBY_VERSION)
gem "rails-footnotes",             :group => :development

group :test do
  gem 'ruby-debug',                :require => nil unless defined?(JRUBY_VERSION)
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
gem 'mongrel',                     :require => nil
gem 'thin',                        :require => nil unless defined?(JRUBY_VERSION)
gem 'glassfish',                   :require => nil if     defined?(JRUBY_VERSION)
