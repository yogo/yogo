source :rubygems

gem "yogo-framework"                            # The Yogo Framework

gem "rails"                                     # Rails application
gem "dm-rails"                                  # DataMapper integration with Rails
gem "jquery-rails"                              # jQuery integration with Rails
gem "compass", ">= 0.10.6"                      # Styling automation for views
gem "haml"                                      # HAML syntax for views
gem "inherited_resources"                       # Simplified Rails controllers
gem "bcrypt-ruby"                               # Encryption for authentication
gem "rails_warden"                              # Warden integration with Rails for authentication

gem "mime-types", :require => "mime/types"      # For uploading data files

gem "pony"                                      # For email feedback
gem "mail"                                      # For email feedback

# Because in 1.9 fastercsv is default, but in 1.8...
platforms(:ruby_18) { gem "fastercsv" }

group(:development, :test) do
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
  # TODO: We need to find out how to remove this
  gem "test-unit", "~> 1.2.1",     :require => nil # This is annoying that is is required.
  # Debugger requirements
  platforms(:mri_19) { gem "ruby-debug19", :require => nil }
  platforms(:mri_18) { gem "ruby-debug",   :require => nil }
end
