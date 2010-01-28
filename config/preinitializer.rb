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
  require File.dirname(__FILE__) / '..' / :vendor / :bundled / :environment
rescue LoadError => e
  puts "Bundler environment could not be loaded! Ensure bundler is installed and run 'gem bundle'."
  exit 1
end
