require 'file_type_error'

class Project
  include DataMapper::Resource
  include Yogo::Pagination
  
  # has 1, :yogo_collection, :model => "Yogo::Collection"

  property :id, Serial
  property :name, String, :required => true
  
  after :create, :initialize_collection

  def yogo_collection
    @yogo_collection || Yogo::Collection.first(:project_id => self.id)
  end
  
  def yogo_collection=(collection)
    # @yogo_collection = collection
    collection.project_id = self.id
    collection.save
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
  
  def process_csv(datafile)
    raise FileTypeError unless datafile.content_type == "text/csv" || datafile.content_type == "text/comma-separated-values"
    name = File.basename(datafile.original_filename).sub(/[^\w\.\-]/,'_')
    file_name = File.join("tmp/data/", name)

    # Write this to a local file temporarily, this should process the contents really
    File.open(file_name, 'w') { |f| f.write(datafile.read) }
    
    # Process the contents
    #create a new reflection to create a new model based on the csv
    DataMapper::Reflection..create_model_from_csv(file_name)

    
    # Remove the file
    File.delete(file_name) if File.exist?(file_name)
  end
end
