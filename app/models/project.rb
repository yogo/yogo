class Project
  include DataMapper::Resource
  include Yogo::Pagination
  
  # has 1, :yogo_collection, :model => "Yogo::Collection"

  property :id, Serial
  property :name, String, :required => true
  
  after :create, :initialize_collection

  def yogo_collection
    Yogo::Collection.first(:project_id => self.id)
  end

  # to_param is called by rails for routing and such
  def to_param
    id.to_s
  end
  
  # respond to #new_record for legacy purposes
  def new_record?
    new?
  end
  
  # A useful method
  # Mostly a joke, this can be removed.
  def puts_moo
    puts 'moo'
  end

  # initialize a yogo_collection for the project
  def initialize_collection
    Yogo::Collection.create(:project_id => self.id)
  end

end
