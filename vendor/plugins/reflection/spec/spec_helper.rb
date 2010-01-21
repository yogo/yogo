require 'rubygems'
require 'dm-core'
require 'reflection'
require 'dm-persevere-adapter'

DataMapper.setup(:persevere, {:adapter => 'persevere',
                              :host    => 'localhost',
                              :port    => '8080',
                              :uri     => 'http://localhost:8080'
                             })