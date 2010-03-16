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
models = DataMapper::Reflection.reflect(:default)

models.each{|m| m.send(:include,Yogo::DataMethods) }
models.each{|m| m.properties.sort! }
