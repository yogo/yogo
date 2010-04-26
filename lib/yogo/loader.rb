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
      
      models.each do |model|
        
        model_name = model.name.capitalize.gsub(/[^\w]/, '_')
        mphash = {}
        
        model.properties.each do |prop| 
          type = prop.type == String ? DataMapper::Types::Text : prop.type
          mphash[prop.name] = { :type => type } 
          mphash[prop.name].merge!({:default => prop.default}) if prop.default? 
        end

        yogo_model = project.add_model(model_name, mphash)

        yogo_model.auto_migrate!
        
        # Create each instance of the class
        model.all.each do |item| 
          newitems = Hash.new
          item.attributes.each_pair do |attr, val|
            newitems["yogo__#{attr}"] = val
          end
          yogo_model.create(newitems)
        end
      end
      
      models.each do |model|
        DataMapper::Model.descendants.delete(model)
        Object.send(:remove_const, model.name.to_sym) 
      end
      
      DataMapper::Reflection.reflect(:default)
    end
  end
end