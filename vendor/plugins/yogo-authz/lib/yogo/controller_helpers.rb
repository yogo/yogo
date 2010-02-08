# Yogo Authorization Module
# Copyright (c) 2009 Montana State University
#
# FILE: controller_helper.rb
# This module adds some helper methods for discovering the Controller objects of the rails project.
module Yogo
  module ControllerHelpers

    def self.included(base)
      base.send :extend, ControllerHelpersClassMethods
    end
  
    module ControllerHelpersClassMethods #nodoc

      # Finds all of the controllers under the rails root path.
      # Assumes the controllers have the name *_controller.rb in a controllers directory.
      # Also assumes the class name is /[A-Za-z]Controller/
      #
      # TODO: This is ugly. If someone comes up with a better way of finding the controllers
      # please let us know.
      # TODO: The ActionController:Routing::possible_controllers method does not show controllers
      # from plugins. It would be nice if someone pathched it someday.
      def get_controllers
        paths = $LOAD_PATH.select{ |path| path.match(Rails.root.to_s) }
        paths = paths.select { |path| path.match(/controllers/) }
        paths.each{ |path| path.sub!(/\/\z/, '')}
        paths.uniq!

        # These files are probably controllers.
        files = paths.collect{|path| Dir.glob(path+"/**/*_controller.rb")}.flatten
  
        controllers = []
        files.each do |file_name|
          File.open(file_name) do |file|
            file.each_line do |line|
              matches = line.match(/^\s*((#)|\bclass (\S+Controller))/)
              if matches and not matches[1].eql?('#')
                controllers << (eval "#{matches[3]}")
              end
            end
          end
        end
        return controllers
      end
    end

  end
end