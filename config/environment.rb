# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
#RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )


  # # Required Gems (Install with `rake gems:install`)
  # config.gem "dm-core",              :version => '>=0.10.2'
  # config.gem "dm-timestamps"
  # config.gem "dm-validations"
  # config.gem "dm-is-nested_set"
  # config.gem "dm-ar-finders"
  # config.gem "dm-persevere-adapter", :version => '>=0.21', :lib => false
  # config.gem "dm-aggregates"
  # config.gem "dm-serializer"  # => this causes a CSV Row Superclass error?! 
  # config.gem "do_sqlite3",           :lib => false
  # config.gem "rails_datamapper"
  # config.gem "authlogic",            :version => '>=2.1.3'
  # 
  # # JRUBY sensitive gems
  # if defined?(JRUBY_VERSION)
  #   config.gem "json_pure",          :version => '>=1.2.0', :lib => false
  #   config.gem "glassfish",          :version => '>=1.0.2', :lib => false
  # else
  #   config.gem "json",               :version => '>=1.2.0', :lib => false
  # end


  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
end