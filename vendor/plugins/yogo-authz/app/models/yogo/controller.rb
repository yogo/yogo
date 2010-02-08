# Yogo Authorization Module
# Copyright (c) 2009 Montana State University
#
# FILE: controller.rb
# I think this should be a class containing the controllers, descriptions of the controllers.
class Yogo::Controller
  include Yogo::ControllerHelpers 
  
  def self.all
    @_controllers ||= self.get_controllers
  end
  
  def self.declaired_authorizations
    @_declaired__controllers ||= self.all.select{|cont| cont.declaired_ }
  end
  
  def self.undeclaired_authorizations
    @_undeclaired__controllers ||= self.all.select{|cont| !cont.declaired_ }
  end
end