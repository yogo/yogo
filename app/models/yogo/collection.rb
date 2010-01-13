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
      @schemas = {}
      retrieve_yogo_models
      self
    end
  end

  def yogo_schemas
    @schemas
  end
  
  def add_yogo_schema(json)
    # handle json array
    json.each do |j|
      DataMapper::Reflection.create_model_from_json(j, @project_class).each do |m|
        repository(:yogo).adapter.put_schema(m.model.to_json_schema_compatible_hash)
        @schemas[m.model.name] = m
      end
    end
  end
  
  def valid?
    !@project.nil?
  end
  
  def project_class
    @project_class
  end
  
  private
  
  def retrieve_yogo_models
    # grab the project scoped schemas from the datastore
    json = repository(:yogo).adapter.get_schema("[?RegExp('yogo\/#{project_key}.*').test(id)]")
    # reflect them into models
    add_yogo_schema(json) if json
  end
  
  def instantiate_project
    klass = "Yogo::" + project_key.classify
    eval <<-KLASS
    class #{klass}
      
    end
    KLASS
    @project_class = klass.constantize
  end

end


