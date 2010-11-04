source :rubygems

gem "data_mapper"
gem "dm-is-list"
gem "dm-is-versioned"

gem "yogo-framework", :path =>  "../yogo-framework"
# gem "yogo-project",   :git =>  "git://github.com/yogo/yogo-project.git"
gem "yogo-project",   :path => "../yogo-project"

gem "jquery-rails"

# Extra supporting gems
gem "rails"
gem "dm-rails"
gem "inherited_resources"
gem "carrierwave"
gem "compass", ">= 0.10.6"
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

platforms(:ruby_18) { gem "fastercsv" }

group(:development, :test) do
  gem "capistrano",                :require => nil
  gem "bluecloth",                 :require => nil # Required for YARD
  gem "rake",                      :require => nil
  gem 'rspec'
  gem 'rspec-core',                :require => 'rspec/core'
  gem 'rspec-expectations',        :require => 'rspec/expectations'
  gem 'rspec-mocks',               :require => 'rspec/mocks'
  gem 'rspec-rails'
  gem "yard",                      :require => nil
  gem "yardstick",                 :require => nil
  gem "jeweler",                   :require => nil
  gem "test-unit",    "~> 1.2.1",  :require => nil # This is annoying that is is required.

  platforms(:mri_19) { gem "ruby-debug19", :require => nil }
  platforms(:mri_18) { gem "ruby-debug",   :require => nil }

end
