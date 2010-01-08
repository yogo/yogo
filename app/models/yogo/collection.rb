# The Yogo::Collection is not a database object, but rather a bridge between the 
# traditionally databased models in the app with the dynamically created models in the 
# yogo datastore.  The Collection is repsponsible for storage, retrieval and reflection.
#
class Yogo::Collection

  attr_accessor :project

  # A Collection requires a project to attach itself to.  It creates a Project Key from the 
  # name and ID of the project
  # The project can be anything, but it must respond to #id and #name.
  def initialize(project)
    @project = project
    @project_key = "#{@project.name}_#{@project.id}"
  end

  def yogo_schema(name = nil)
    @schemas ||= []
    @schemas <<  Yogo::Schema.new('Person')
    name ? @schemas.select{|s| s.name == name}[0] : @schemas
  end
  
  def yogo_data(schema)
   yogo_schema.select{|s| s.name == schema }.first.yogo_data
  end
end

class Yogo::Schema
  
  def self.default_repository_name 
    :yogo
  end

  def initialize(name)
    @name = name
    @data = []
    10.times do 
      @data << Yogo::Data.new
    end
  end
  
  def yogo_data
    @data
  end
  
  def to_s
    @name
  end
  
  def to_json
    {
      :name => @name,
      :data => @data
    }.to_json
  end
end


class Yogo::Data
  
  def self.default_repository_name 
    :yogo
  end
  
  def initialize
    @name = "Faker::Name.name"
  end
  
  def to_s
    @name
  end
  
  def attributes
    [:name, :id]
  end
  
  def to_json
    {:name => @name}.to_json
  end
end