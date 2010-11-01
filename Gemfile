source :rubygems

gem "yogo-framework", :path =>  "../yogo-framework"

# Extra supporting gems
gem "rails"
gem "inherited_resources"
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
