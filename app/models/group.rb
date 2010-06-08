# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: group.rb
# Groups for projects and users. A Project will have groups, and users will belong to groups

class Group
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String, :required => true
  
  has n, :users, :through => Resource
  belongs_to :project, :required => false

end
