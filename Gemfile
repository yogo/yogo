source :rubygems

DATAMAPPER = "git://github.com/datamapper"

gem "dm-core"
gem "dm-is-list"
gem "dm-migrations"
gem "dm-is-versioned"
gem "dm-validations"

# 1.0 Release of dm-types has problems with UUID properties, use git master
gem "dm-types",       "~> 1.0.0",     :git => "#{DATAMAPPER}/dm-types.git",
                                      :ref => "674738f2a94788b975e9",
                                      :require => false # don't require dm-type/json

#gem "yogo-project", :git => "git://github.com/yogo/yogo-project.git"
gem "yogo-project", :path => "../yogo-project"

# Adapters to store or access data
gem "dm-persevere-adapter", "0.72.0"
gem "dm-sqlite-adapter"
gem "dm-postgres-adapter"
gem "dm-rest-adapter"

# Extra supporting gems
gem "rails",                "2.3.8"
gem "inherited_resources",  "~> 1.0.6"
gem "carrierwave"
gem "compass"
gem "bcrypt-ruby"
gem "haml"
gem "mime-types",                   :require => "mime/types"
gem "uuidtools"
gem 'rails_warden'
gem "json",                         :require => nil
gem 'pony'
gem 'polyglot'
gem 'treetop'
gem 'mail'

platforms(:ruby_18, :jruby) { gem "fastercsv" }

# Switching 1.8.7/1.9 breaks for now
group :development, :test do
  platforms(:ruby_19) do
    gem "ruby-debug19",             :require => "ruby-debug"
    gem "rack-debug19",             :require => "rack-debug"
  end

  platforms(:ruby_18) do
    gem "ruby-debug"
    gem "rack-debug"
  end
end

group :development do
  gem "capistrano",                 :require => nil
  gem "rails-footnotes"
  gem "test-unit",        "1.2.3"
  gem "bluecloth",                  :require => nil # Required for YARD
end

group :test do
  gem "rake",                      :require => nil
  gem "rspec",        "~>1.3.0",   :require => nil
  gem "rspec-rails",  "~>1.3.2",   :require => "spec/rails"
  gem "yard",                      :require => nil
  gem "yardstick",                 :require => nil
  gem "jeweler",                   :require => nil
end
