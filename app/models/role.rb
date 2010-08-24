
# # Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: Role.rb
# Roles for projects and users. A Project will have Roles, and users will belong to Roles

class Role
  include DataMapper::Resource
  include Facet::DataMapper::Resource

  property :id, Serial
  property :name, String, :required => true, :unique => true
  property :description, Text
  property :permissions, Yaml, :default => [].to_yaml

  has n, :memberships
  has n, :projects, :through => :memberships
  has n, :users, :through => :memberships

  is :list

  def self.permission_sources
    [Project, Membership,
      Voeis::DataStream,
      Voeis::DataStreamColumn,
      Voeis::MetaTag,
      Voeis::SensorType,
      Voeis::SensorValue,
      Voeis::Site,
      Voeis::Unit,
      Voeis::Variable]
  end

  def self.available_permissions
    @_availaible_permissions ||= permission_sources.map {|ps| ps.to_permissions}.flatten
  end

  def self.available_permissions_by_source
    source_hash = Hash.new
    permission_sources.each { |ps| source_hash[ps.name] = ps.to_permissions }
    source_hash
  end

  def has_permission?(permission)
    actions.include?(permission)
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
