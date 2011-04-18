# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: environment.rb
#
#
# Be sure to restart your server when you modify this file

# Load the rails application
require File.expand_path('../application', __FILE__)

require 'rack/rql'
Yogo::Application.configure do
  config.middleware.insert_before(ActionDispatch::Head, Rack::RqlQuery)
end

# Initialize the rails application
Yogo::Application.initialize!


