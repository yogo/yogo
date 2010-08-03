require 'yogo/project'

module Yogo
  class Project
    property :is_private,      Boolean, :required => true, :default => false
    
    has n, :groups
  end
end