
# # Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: settings.rb
# Implementing a settings configuration class.

module Yogo

  # This allows for storing and retrieving settings across Yogo Applications
  # 
  # @author Robbie Lamb robbie.lamb@gmail.com
  class Setting
    include DataMapper::Resource  

    # puts "Loading Yogo::Setting"

    # storage_names[:default] = 'yogo__settings'
    # storage_names[:yogo_settings_cache] = 'yogo_settings'

    property :id,     Serial
    property :name,   String
    property :value,  Object
  
    # @private
    @@cache = {}
    # @private
    @@settings_files = []
    # @private
    @@settings_setup = false
  
    ##
    # Used to query the settings basied on a key
    #
    # @example
    #   if Yogo::Setting[local_only]
    #     # Be useful
    #   end
    # 
    # @param [String or Symbol] key 
    #  The key to retrieve
    # 
    # @return [Object or nil] Returns the object at the key or nil if it doesn't exist
    #
    # @author Robbie Lamb robbie.lamb@gmail.com
    # 
    # @api public
    def self.[](key)
      key = key.to_s if key.is_a? Symbol
      self.setup unless @@settings_setup
      check_cache(key) 
    end
  
    ##
    # Used to set a value for a particular key
    # 
    # @example
    #   Yogo::Setting[local_only] = false
    # 
    # @param [String or Symbol] key 
    #   key to store
    # @param [Object] value 
    #   Any object to be stored in the key
    # 
    # @return [Boolean] returns if successful
    #
    # @author Robbie Lamb robbie.lamb@gmail.com
    # 
    # @api public
    def self.[]=(key,value)
      key = key.to_s if key.is_a? Symbol
      self.setup unless @@settings_setup
      self.store_cache(key,value)
      self.store_database(key,value)
    end
  
    ##
    # Used to get the keys of the current setting
    #
    # @example
    #   Yogo::Setting.keys
    #
    # @return [Array] an array of all of the keys in the current settings
    #
    # @author Robbie Lamb robbie.lamb@gmail.com
    #
    # @api public
    def self.keys
      @@cache.keys
    end

    ##
    # Loads YAML files for the default settings to be used
    # 
    # This is primairly used during testing.
    # 
    # @example
    #   Yogo::Setting.load_defaults(Dir.glob(Rails.root.to_s+"/vendor/gems/**/config/settings.yml")
    #                  Dir.glob(Rails.root.to_s+"/config/settings.yml")
    #                 )
    # 
    # @param [Array] files 
    #   An array of files to load the defaults from
    # 
    # @return [Array] an array of files. This isn't useful.
    # 
    # @author Robbie Lamb robbie.lamb@gmail.com
    # 
    # @api private
    def self.load_defaults(*files)
      files.each do |file|
        @@settings_files << Dir.glob(file)
      end
      @@settings_files.flatten!

      @@settings_files.each{ |file|
        config = YAML.load_file(file)
        @@cache.merge!(config) unless config == false
      }
    end

    private

    ##
    # Used to check the cache for the existence of a key
    #
    # @example
    #  Yogo::Setting.check_cache("key_name")
    #
    # @param [String] key
    #  the name of a key to check in the cache
    #
    # @return [Boolean] returns true is the key exist in the cache
    #
    # @author Robbie Lamb robbie.lamb@gmail.com
    #
    # @api private
    def self.check_cache(key)
      @@cache[key] if @@cache.has_key?(key)
    end
    
    # Used to store a key-value pair in the cache
    #
    # @example
    #  store_cache("key_name", 112)
    #
    # @param [String] key
    #  the name of a key to store in the cache
    # @param [Object] value
    #  the value to store in the cache associated with the key, can be any type or object
    #
    # @return [Object] returns the cache object stored
    #
    # @author Robbie Lamb robbie.lamb@gmail.com
    #
    # @api private
    def self.store_cache(key, value)
      @@cache[key] = value
    end
  
    ##
    # Used to store key-value pair in a specified storage_location
    #
    # @example
    #  store("key_name", 112, "yogo")
    #
    # @param [String] key
    #  the name of a key to store in the cache
    # @param [Object] value
    #  the value to store in the cache associated with the key, can be any type or object
    # @param [String] storage_name
    #  the string containing the name of the location to store the key-value pair 
    # 
    # @return [Object] returns the object stored
    #
    # @author Robbie Lamb robbie.lamb@gmail.com
    #
    # @api private
    def self.store_database(key, value, storage_name = :default)
      repository(storage_name) do
        record = first(:name => key) || self.create(:name => key)
        record.value = value
        record.save
      end
    end
    
    ##
    # Used to setup the storage and cache
    #
    # @example
    #  setup
    #
    # @return [Boolean] returns true if the setup was successful
    #
    # @author Robbie Lamb robbie.lamb@gmail.com
    #
    # @api private
    def self.setup
      if !@@settings_setup
        begin
          self.reset_database! unless self.storage_exists?(:default)
          self.reset_cache!
          @@settings_setup = true
        rescue
          # NOOP!
        end 
      end
    end
    
    # Reset the database and in memory cache to the file defaults
    #
    # @example
    #  reset!
    #
    # @return [Boolean] returns true if the reset was successful
    #
    # @author Robbie Lamb robbie.lamb@gmail.com
    #
    # @api private
    def self.reset!
      self.reset_database!
      self.reset_cache!
      @@settings_setup = true
    end
    
    # Reset the persistant storage
    #
    # @example
    #  reset_database!
    #
    # @return [Boolean] returns true if the reset was successful
    #
    # @author Robbie Lamb robbie.lamb@gmail.com
    #
    # @api private
    def self.reset_database!
      self.auto_migrate!
    end
    
    # Reset the in memory cache from the files and persistant storage
    #
    # @example
    #   reset_cache!
    #
    # @return [Yogo::Setting] returns it's self. Not useful.
    #
    # @author Robbie Lamb robbie.lamb@gmail.com
    #
    # @api private
    def self.reset_cache!
      @@cache = {}
      if @@settings_files.empty?
        self.load_defaults(Dir.glob(Rails.root.to_s+"/vendor/gems/**/config/settings.yml"), # Gem settings
                           Dir.glob(Rails.root.to_s+"/vendor/plugins/**/config/settings.yml"), # plugin settings
                           Dir.glob(Rails.root.to_s+"/config/settings.yml") # App settings
                          )
      else 
        self.load_defaults
      end
      self.all.each{|setting|  store_cache(setting.name, setting.value) }
    end
    
  end  
end