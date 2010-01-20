bundle_path "vendor/bundled"
bin_path "vendor/bundled/bin"

source "http://gemcutter.org"

gem "rails", "2.3.5"
gem "rake"
gem "dm-core", "0.10.2"
gem "dm-timestamps"
gem "dm-validations"
gem "dm-is-nested_set"
gem "dm-ar-finders"
gem "dm-persevere-adapter", "0.21.0", :require_as => nil
gem "dm-serializer", "0.10.2", :path => "vendor/gems/dm-serializer-0.10.2"
gem "dm-aggregates"
gem "do_sqlite3", "0.10.1"
gem "rails_datamapper"
gem "authlogic", "2.1.3"
# JRUBY sensitive gems
if defined?(JRUBY_VERSION)
  gem "json_pure", '1.2.0', :require_as => nil
else
  gem "json",      '1.2.0', :require_as => nil
end

gem "rails-footnotes", :only => :development

gem 'rspec',        '1.3.0',  :require_as => nil, :only => :test
gem 'rspec-rails',  '1.3.2',  :require_as => 'spec/rails', :only => :test
gem 'factory_girl', '1.2.3',  :only => :test