# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: reflections.rb
# 
#
require 'datamapper/factory'

# Reflect Yogo data into memory
DataMapper::Reflection.reflect(:yogo) unless ENV['NO_PERSEVERE']
