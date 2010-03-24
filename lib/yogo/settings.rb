# Yogo Data Management Toolkit
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
  class Settings
    include DataMapper::Resource  

    storage_names[:default] = 'yogo_settings'
    # storage_names[:yogo_settings_cache] = 'yogo_settings'

    # property :id,    Serial
    property :name,   String, :key => true
    property :value,  Object
  
    # @private
    @@cache = {}
    # @private
    @@settings_files = []
    # @private
    @@settings_setup = false
    
    # @return [Array] files This isn't very useful
    # FIXME @api private, semipublic, or public
    # Loads YAML files for the default settings to be used.
    # @param [Array] files An array of files to load the defaults from
    # 
    # @author Robbie Lamb robbie.lamb@gmail.com
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
  
    # Used to query the settings basied on a key
    #
    # @param [String or Symbol] key The key to retrieve
    # @return [Object or nil] Returns the object at the key or nil if it doesn't exist.
    #
    # @author Robbie Lamb robbie.lamb@gmail.com
    def self.[](key)
      key = key.to_s if key.is_a? Symbol
      self.setup unless @@settings_setup
      response = check_cache(key) 
      if response.nil?
        response = check_database(key)
        store_cache(key, response) unless response.nil?
      end

      unless response.nil?
        return response 
      end
    end
  
    # Used to set a value for a particular key
    # 
    # @param [String or Symbol] key key to store
    # @param [Object] value Any object to be stored in the key
    # 
    # @author Robbie Lamb robbie.lamb@gmail.com
    def self.[]=(key,value)
      key = key.to_s if key.is_a? Symbol
      self.setup unless @@settings_setup
      self.store_cache(key,value)
      self.store_database(key,value)
    end
  
    # @author Robbie Lamb robbie.lamb@gmail.com
    # @return [Array] an array of all of the keys in the current settings
    def self.keys
      @@cache.keys
    end
  
    private
  
    # @author Robbie Lamb robbie.lamb@gmail.com
    # @private
    def self.check_cache(key)
      # puts "Checking cache for #{key}"
      # repository(:yogo_settings_cache) { self.get(key) }
      @@cache[key] if @@cache.has_key?(key)
    end
  
    # @author Robbie Lamb robbie.lamb@gmail.com
    # @private
    def self.check_database(key)   
      # puts "Checking database for #{key}"
      result = repository(:default) { self.get(key) }
      return result.value unless result.nil?
    end
  
    # @author Robbie Lamb robbie.lamb@gmail.com
    # @private
    def self.store_cache(key, value)
      # puts "Storing #{key} in cache"
      # self.store(key, value, :yogo_settings_cache)
      @@cache[key] = value
    end
  
    # @author Robbie Lamb robbie.lamb@gmail.com
    # @private
    def self.store_database(key,value)
      # puts "Storing #{key} in database"
      self.store(key, value, :default)
    end
  
    # @author Robbie Lamb robbie.lamb@gmail.com
    # @private
    def self.store(key, value, storage_name)
      repository(storage_name) do
        record = self.get(key) || self.new(:name => key)
        record.value = value
        record.save
      end
    end
    
    # @author Robbie Lamb robbie.lamb@gmail.com
    # @private
    def self.setup
      begin
        self.reset_database! unless self.storage_exists?(:default)
        self.reset_cache!
        @@settings_setup = true
      rescue
        # NOOP!
      end unless @@settings_setup
    end
    
    # @author Robbie Lamb robbie.lamb@gmail.com
    # @private
    def self.reset!
      self.reset_database!
      self.reset_cache!
      @@settings_setup = true
    end
    
    # @author Robbie Lamb robbie.lamb@gmail.com
    # @private
    def self.reset_database!
      self.auto_migrate!
    end
    
    # @author Robbie Lamb robbie.lamb@gmail.com
    # @private
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
      self.all{|setting| store_cache(setting.name, setting.value)}
    end
    
  end  
end