# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path(File.join(File.dirname(__FILE__),'..','config','boot'))

require 'rake'
require 'rake/rdoctask'
require 'rake/testtask'
require 'tasks/rails'

require 'net/http'

if not defined? JRUBY_VERSION
  # Start persvr
  Rake.application['persvr:drop'].invoke
  Rake.application['persvr:start'].invoke

  config = YAML.load_file(File.expand_path(File.join(File.dirname(__FILE__),'..','config','database.yml')))

  times_tried = 0
  begin
    sleep 0.25
    times_tried += 1
    Net::HTTP.new(config[Rails.env]['host'], config[Rails.env]['port']).send_request('GET', '/', nil, {})
  rescue Exception => e
    retry if times_tried < 20
    puts 'The perserver server didn\'t come up properly.'
    Rake.application['persvr:stop'].invoke
    exit 1
  end
end

require File.expand_path(File.join(File.dirname(__FILE__),'..','config','environment'))

require 'spec/autorun'
require 'spec/rails'
require 'factory_girl'
require 'factories'
require 'datamapper/factory'

begin
  require 'ruby-debug'
rescue Exception => e
  puts "ruby-debug not loaded"
end


# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

# Require and migrate DataMapper models
Dir[File.expand_path(File.join(Rails.root,'app','models','*.rb'))].each {|f| require f}
DataMapper.auto_migrate!

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  # config.use_transactional_fixtures = true
  # config.use_instantiated_fixtures  = false
  # config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

  # == Fixtures
  #
  # You can declare fixtures for each example_group like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so right here. Just uncomment the next line and replace the fixture
  # names with your fixtures.
  #
  # config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
  #
  # You can also declare which fixtures to use (for example fixtures for test/fixtures):
  #
  # config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  #
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  #
  # == Notes
  #
  # For more information take a look at Spec::Runner::Configuration and Spec::Runner
  config.before(:all) {
    # Start Persevere

  }

  config.after(:all) {
    # puts "Stopping perserver"
    # Rake.application['persvr:stop'].invoke
  }

  
end
