# The Yogo::Collection is not a database object, but rather a bridge between the 
# traditionally databased models in the app with the dynamically created models in the 
# yogo datastore.  The Collection is repsponsible for storage, retrieval and reflection.
#
module Yogo
  
  class Collection

    attr_accessor :project

    # A Collection requires a project to attach itself to.  It creates a Project Key from the 
    # name and ID of the project
    # The project can be anything, but it must respond to #id and #name.
    # LBR Warning: Don't spell out 'project' as the incoming param because it will just call the
    # accessor method and RETURN NIL EVERY TIME AAARGH.
    def initialize(projekt)
      @project = projekt
    end

    def models
      DataMapper::Model.descendants.select do |m| 
        m.name =~ /Yogo::#{project_key}::/ && !m.deleted?
      end
    end
  
    def add_model(hash)
      DataMapper::Factory.build(namespace(hash), :yogo)
    end
  
    def valid?
      !@project.nil?
    end
  
    def project_key
      project.name.gsub(/[^\w]/,'')
    end

    def delete_models!
      models.each do |m| 
        m.auto_migrate_down! 
        m.delete!
      end
    end

    #
    # Private Methods
    #
    private
    
    def namespace(hash)
      unless hash['id'] =~ /^Yogo\/#{project_key}\/\w+/
        hash['id'] = "Yogo/#{project_key}/#{hash['id']}"
      end
      hash
    end
    
  end
end

