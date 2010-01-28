# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: loader.rb
# 
#
module Yogo
  class Loader
    ##
    # load a repository into a new project
    # 
    # @param [Slug] repo the repository to load the project from
    # @param [String] name the project name in normal form, e.g. "Example Project"
    #
    def self.load(repo, name)
      # Iterate through each model and make it in persevere, then copy instances
      DataMapper::Reflection.reflect(repo).each do |model|
        mphash = Hash.new
        model.properties.each do |prop| 
          mphash[prop.name] = { :type => prop.type, :key => prop.key?, :serial => prop.serial? } 
          mphash[prop.name].merge!({:default => prop.default}) if prop.default? 
        end
        model_hash = { :name       => model.name.capitalize.gsub(/[^\w]/, '_'),
                       :modules    => ["Yogo", name.camelize.gsub(/[^\w]/, '') ],
                       :properties => mphash
                     }
        yogo_model = DataMapper::Factory.build(model_hash, :yogo)
        yogo_model.auto_migrate!
        # Create each instance of the class
        model.all.each{ |item| yogo_model.create!(item.attributes) }
      end
      Project.create(:name => name)
      DataMapper::Reflection.reflect(:yogo)
    end
  end
end