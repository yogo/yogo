require 'rubygems'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))

require 'dm-core'
require 'dm-reflection'

require 'spec'
require 'spec/autorun'

ENV["SQLITE3_SPEC_URI"]  ||= 'sqlite3::memory:'
ENV["MYSQL_SPEC_URI"]    ||= 'mysql://localhost/dm-reflections_test'
ENV["POSTGRES_SPEC_URI"] ||= 'postgres://postgres@localhost/dm-reflection_test'


def setup_adapter(name, default_uri = nil)
  begin
    DataMapper.setup(name, ENV["#{ENV['ADAPTER'].to_s.upcase}_SPEC_URI"] || default_uri)
    Object.const_set('ADAPTER', ENV['ADAPTER'].to_sym) if name.to_s == ENV['ADAPTER']
    true
  rescue Exception => e
    if name.to_s == ENV['ADAPTER']
      Object.const_set('ADAPTER', nil)
      warn "Could not load do_#{name}: #{e}"
    end
    false
  end
end

ENV['ADAPTER'] ||= 'sqlite3'
setup_adapter(:default)


Spec::Runner.configure do |config|

end


# # From reflection
# 
# require 'pathname'
# require 'rubygems'
# require 'reflection'
# require 'dm-core'
# require File.expand_path(File.join(File.dirname(__FILE__),'..', 'reflection'))
# require File.expand_path(File.join(File.dirname(__FILE__),'../../../../..', 'gems', "dm-persevere-adapter-0.16.0", 'lib', 'persevere_adapter'))
# gem     'rspec'
# require 'spec'
# 
# DataMapper.setup(:persevere, {:adapter => 'persevere',
#                               :host    => 'localhost',
#                               :port    => '8080',
#                               :uri     => 'http://localhost:8080'
#                              })
# DataMapper::Reflection.setup(:binding => binding, :database => :persevere)
# 
# module Project1
# end