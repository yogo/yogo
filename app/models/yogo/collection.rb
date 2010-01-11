# The Yogo::Collection is not a database object, but rather a bridge between the 
# traditionally databased models in the app with the dynamically created models in the 
# yogo datastore.  The Collection is repsponsible for storage, retrieval and reflection.
#
class Yogo::Collection

  attr_accessor :project, :project_key

  # A Collection requires a project to attach itself to.  It creates a Project Key from the 
  # name and ID of the project
  # The project can be anything, but it must respond to #id and #name.
  # LBR Warning: Don't spell out 'project' as the incoming param because it will just call the
  # accessor method and RETURN NIL EVERY TIME AAARGH.
  def initialize(proj)
    if proj
      @project = proj
      @project_key = "#{proj.name.gsub(/[^\w]/,'')}"
      instantiate_project
    end
  end

  def yogo_schemas
    @schemas ||= []
    @schemas <<  Yogo::Schema.new('Person')
  end
  
  def add_yogo_schema(json)
    @schemas << DataMapper::Reflection.create_model_from_json(json)
  end
  
  def valid?
    !@project.nil?
  end
  
  def project_class
    @project_class
  end
  
  private
  
  def instantiate_project
    eval <<-KLASS
    class Yogo::#{project_key.classify}
      
    end
    KLASS
    @project_class = ("Yogo::" + project_key.classify).constantize
  end

end


