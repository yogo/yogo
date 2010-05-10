# Copyright (c) 2009 Montana State University
#
# FILE: model_authorization_system.rb
# This adds authorization helpers controllers and actions.
module Yogo
  module ModelAuthorizationSystem
    
    def self.included(base)

      eval <<-END_CLASS
             class Yogo::#{base.name}Group < Yogo::Group
                belongs_to :#{base.name.underscore}, :model => "#{base.name}", :child_key => [:foreign_id]
             end
           END_CLASS
           
      
      base.send :extend, ClassMethods
      base.send :include, InstanceMethods

      base.send(:property, :yogo_string, String)
      # 1.0/0 is the same as 'n'
      base.send(:has, 1.0/0, :groups, :model => "Yogo::#{base.name}Group", :child_key => [:foreign_id])
      base.send(:has, 1.0/0, :users, :through => :groups, :model => "User")

      # include Yogo::ModelAuthorizationSystem::ClassMethods
      # extend Yogo::ModelAuthorizationSystem::InstanceMethods
      
    end
    
    module ClassMethods

      def add_routes(map, parents = [])
        generate_groups_controller(parents)
        map.namespace :yogo do |yogo|
          yogo.resources :groups, :controller => "#{self.name.underscore}_groups"
        end
      end

      private
      
      def generate_groups_controller(parents)
        eval <<-END_CLASS
          class Yogo::#{self.name}GroupsController < ApplicationController
            
            private
            def self.parent_class
              #{self.name}
            end
            
            def parent_class
              self.class.parent_class
            end
          end
        END_CLASS
        
        controller = eval("Yogo::#{self.name}GroupsController")
        controller.send(:include, Yogo::Templates::GroupsController)
      end

    end
    
    module InstanceMethods
      
      def permit?(user, controller = '', action = '', options = {})
        true
      end
      
    end
    
  end
end