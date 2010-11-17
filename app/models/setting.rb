
# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: settings.rb
# Implementing a settings configuration class.

# This allows for storing and retrieving settings across Yogo Applications
#
# @author Robbie Lamb robbie.lamb@gmail.com
class Setting
  include DataMapper::Resource
  include Facet::DataMapper::Resource

  property :id,     Serial
  property :name,   String, :unique => true
  property :value,  Object

  # @private
  @@cache = {}

  ##
  # Used to query the settings basied on a key
  #
  # @example
  #   if Setting[local_only]
  #     # Be useful
  #   end
  #
  # @param [String or Symbol] key
  #  The key to retrieve
  #
  # @return [Object or nil] Returns the object at the key or false if it doesn't exist
  #
  # @author Robbie Lamb robbie.lamb@gmail.com
  #
  # @api public
  def self.[](key)
    key = key.to_s if key.is_a? Symbol
    setting = if @@cache.has_key?(key) 
        @@cache[key] 
      else
        temp = first(:name => key)
        @@cache[key] = temp.nil? ? nil : temp.value
    end
    setting.nil? ? false : setting
  end

  ##
  # Used to set a value for a particular key
  #
  # @example
  #   Setting[local_only] = false
  #
  # @param [String or Symbol] key
  #   key to store
  # @param [Object] value
  #   Any object to be stored in the key
  #
  # @return [Boolean] returns true if successful
  #
  # @author Robbie Lamb robbie.lamb@gmail.com
  #
  # @api public
  def self.[]=(key,value)
    key = key.to_s if key.is_a? Symbol
    @@cache[key] = value
    setting = first_or_create(:name => key)
    setting.value = value
    setting.save
  end

  ##
  # Used to get the keys of the current setting
  #
  # @example
  #   Setting.names
  #
  # @return [Array] an array of all of the keys in the current settings
  #
  # @author Robbie Lamb robbie.lamb@gmail.com
  #
  # @api public
  def self.names
    all.map { |setting| setting.name.to_s }
  end
end