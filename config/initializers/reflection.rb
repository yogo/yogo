# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: reflections.rb
# 
#

models = []

# Hack, Kludge, Requisite ugly code.
Project.first

# Reflect Yogo data into memory
models = DataMapper::Reflection.reflect(:yogo) unless ENV['NO_PERSEVERE']

models.each{|m| m.send(:include,Yogo::DataMethods) unless m.included_modules.include?(Yogo::DataMethods)}
models.each{|m| m.properties.sort! }

