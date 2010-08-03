
# # Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: Role.rb
# Roles for projects and users. A Project will have Roles, and users will belong to Roles

class Role
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :required => true
  property :description, String
  property :permissions, Yaml, :default => [].to_yaml

  has n, :users, :through => Resource
  belongs_to :project, :required => false

  def permission_sources
    [Project]
  end

  def available_permissions
    permission_sources.map {|ps| ps.to_permissions}.flatten
  end

  def available_permissions_by_source
    source_hash = Hash.new
    permission_sources.each { |ps| source_hash[ps.name] = ps.to_permissions }
    source_hash
  end

  ##
  # Compatability method for rails' route generation helpers
  #
  # @example
  #   @project.to_param # returns the ID as a string
  #
  # @return [String] the object id as url param
  #
  # @author Yogo Team
  #
  # @api public
  def to_param
    self.id.to_s
  end
end
