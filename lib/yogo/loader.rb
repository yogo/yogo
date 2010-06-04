# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: loader.rb
# 
module Yogo
  class Loader
    ##
    # Loads a repository into a new project
    #
    # @example TODO
    #
    # @param [Slug] repo the repository to load the project from
    # @param [String] name the project name in normal form, e.g. "Example Project"
    #
    # @return [Model] load a repository into a new project
    # 
    # @author Yogo Team
    #
    # @api public
    def self.load(repo, name)
      project = Project.create(:name => name)
      
      # Iterate through each model and make it in persevere, then copy instances
      models = DataMapper::Reflection.reflect(repo, Object, true)
      
      yogo_models = Array.new
      
      # Create models
      models.each do |model|
        mphash = {}
        
        model.properties.each do |prop| 
          type = prop.type == String ? DataMapper::Types::Text : prop.type
          mphash[prop.name] = { :type => type } 
          mphash[prop.name].merge!({:default => prop.default}) if prop.default? 
        end
        yogo_models << project.add_model(model.name, mphash)
      end

      # Wire up relationships
      models.each do |model|
        rhash = {}
        # Deal with relationships
        model.relationships.each do |key,relation|
          puts "Relationship: #{key} => #{relation.inspect}"
        end
      end

      # Migrate them now that they're full of properties and relationships
      yogo_models.each do |model|
        model.auto_migrate!
      end
      
      # Load up instances
      models.each_index do |idx|        
        model = models[idx]
        yogo_model = yogo_models[idx]
        
        model.all.each do |item| 
          newitems = Hash.new
          item.attributes.each_pair do |attr, val|
            newitems["yogo__#{attr}"] = val
          end
          yogo_model.create(newitems)
        end
      end

      # Nuke origional reflected models
      models.each do |model|
        DataMapper::Model.descendants.delete(model)
        Object.send(:remove_const, model.name.to_sym) 
      end
      
      DataMapper::Reflection.reflect(:default)
    end
  end
end