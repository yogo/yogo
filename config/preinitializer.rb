# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: preinitilizer.rb
# 
#
require File.join(File.dirname(__FILE__), '..', 'lib', 'slash_path')
begin
  require File.dirname(__FILE__) / '..' / :'.bundle' / :environment
rescue LoadError
  # Fallback on doing the resolve at runtime.
  require "rubygems"
  require "bundler"
  if Bundler::VERSION <= "0.9.10"
    raise RuntimeError, "Bundler incompatible.\n" +
      "Your bundler version is incompatible with Rails 2.3 and an unlocked bundle.\n" +
      "Run `gem install bundler` to upgrade or `bundle lock` to lock."
  else
    Bundler.setup
  end
end

# This ensures the gems load in the proper order.
require 'dm-core'
require "dm-timestamps"
require "dm-validations"
require "dm-is-nested_set"
require "dm-serializer"
require "dm-aggregates"
require "dm-types"
