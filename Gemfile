source :rubygems

DM_VERSION = "1.1.0"

gem "yogo-framework"                            # The Yogo Framework
gem "yogo-project",                             :git => "git://github.com/yogo/yogo-project.git"

gem "dm-validations"                            # We're validating properties
gem "dm-is-versioned"                           # TODO: This should be provided by yogo-db
gem "dm-types",        DM_VERSION               # To enable UUID types
gem "dm-is-list",      DM_VERSION               # RBAC
gem "dm-migrations",   DM_VERSION
gem "dm-transactions", DM_VERSION
gem "dm-aggregates",   DM_VERSION
gem "dm-timestamps"

# gem "rails"                                     # Rails application
# Only require of rails what we need, not the entire thing.
gem "actionmailer"
gem "actionpack"
gem "activesupport"
gem "railties"

gem "dm-rails",        DM_VERSION               # DataMapper integration with Rails
gem "jquery-rails"                              # jQuery integration with Rails
gem "compass", ">= 0.10.6"                      # Styling automation for views
gem "haml"                                      # HAML syntax for views
gem "inherited_resources"                       # Simplified Rails controllers
gem "bcrypt-ruby"                               # Encryption for authentication
gem "rails_warden"                              # Warden integration with Rails for authentication

gem "mime-types", :require => "mime/types"      # For uploading data files
gem "uuidtools"                                 # This is for memberships

gem 'i18n', "~> 0.4.0"

gem 'exception_notification',      :require => 'exception_notifier'                                   
                                   
gem 'delayed_job',                 :git => 'git://github.com/robbielamb/delayed_job.git'

# Because in 1.9 fastercsv is default, but in 1.8...
platforms(:ruby_18) { gem "fastercsv" }

group(:development, :test) do
  #gem "memprof"
  #gem "ruby-prof"
  gem "dm-visualizer"
  #gem "rails-footnotes", :git => "https://github.com/irjudson/rails-footnotes.git"
  # For rake tasks to work
  gem "rake",                      :require => nil
  # For deployment
  gem "capistrano",                :require => nil
  # RSpec 2.0 requirements
  gem "rspec"
  gem "rspec-core",                :require => "rspec/core"
  gem "rspec-expectations",        :require => "rspec/expectations"
  gem "rspec-mocks",               :require => "rspec/mocks"
  gem "rspec-rails"
  # YARD Documentation
  gem "yard",                      :require => nil
  gem "bluecloth",                 :require => nil
  gem "yardstick"
  # TODO: We need to find out how to remove this
  gem "test-unit", "~> 1.2.1",     :require => nil # This is annoying that is is required.
  # Debugger requirements
  platforms(:mri_19) { gem "ruby-debug19", :require => nil }
  platforms(:mri_18) { gem "ruby-debug",   :require => nil }
end
