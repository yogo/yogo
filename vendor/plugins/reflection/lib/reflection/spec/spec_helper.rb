require 'pathname'
require 'rubygems'
require 'reflection'
require 'dm-core'
require File.expand_path(File.join(File.dirname(__FILE__),'..', 'reflection'))
require File.expand_path(File.join(File.dirname(__FILE__),'../../../../..', 'gems', "dm-persevere-adapter-0.16.0", 'lib', 'persevere_adapter'))
gem     'rspec'
require 'spec'

DataMapper.setup(:persevere, {:adapter => 'persevere',
                              :host => 'localhost',
                              :port => '8080',
                              :uri => 'http://localhost:8080'
                             })
DataMapper::Reflection.setup(:binding => binding, :database => :persevere)

class Project1
end

# class Book
#   include DataMapper::Resource
# 
#   # Persevere only does id's as strings.  
#   property :id, String, :serial => true
#   property :author, String
#   property :created_at, DateTime
#   property :title, String
# end