# Copyright (c) 2009 Montana State University
#
# FILE: model_authorization_system.rb
# This adds authorization helpers controllers and actions.
module Yogo
  module ModelAuthorizationSystem
    
    def self.included(base)
      base.send :include, ClassMethods
      base.send :extend, InstanceMethods
    end
    
    module ClassMethods
      
      property :yogo_something,      Serial
      property :yogo_string,         String
      
      has n, :groups, :model => 'Yogo::Groups'
    end
    
    module InstanceMethods
      
      def permit?
        
      end
      
    end
    
  end
end