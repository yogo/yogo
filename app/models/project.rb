require 'file_type_error'

class Project
  include DataMapper::Resource
  include Yogo::Pagination
  
  property :id, Serial
  property :name, String, :required => true
  
  validates_is_unique   :name
  
  # to_param is called by rails for routing and such
  def to_param
    id.to_s
  end
  
  # respond to #new_record for legacy purposes
  def new_record?
    new?
  end
  
  def process_csv(datafile)
    raise FileTypeError unless datafile.content_type == 'text/csv' || datafile.content_type == 'text/comma-separated-values' || datafile.content_type == 'application/vnd.ms-excel'
    puts datafile.content_type
    name = File.basename(datafile.original_filename).sub(/[^\w\.\-]/,'_')
    file_name = File.join("tmp/data/", name)

    # Write this to a local file temporarily, this should process the contents really
    File.open(file_name, 'w') { |f| f.write(datafile.read) }
    
    # Process the contents
    #create a new reflection to create a new model based on the csv
    model_hash = DataMapper::Reflection::CSV.describe_model(file_name)
    yogo_collection.add_model(model_hash)
    DataMapper::Reflection::CSV.import_data(filename, :yogo)
    
    # Remove the file
    File.delete(file_name) if File.exist?(file_name)
  end
  
  def models
    DataMapper::Model.descendants.select { |m| m.name =~ /Yogo::#{project_key}::/ }
  end
  
  def get_model(name)
    DataMapper::Model.descendants.select { |m| m.name =~ /Yogo::#{project_key}::#{name}/ }[0]
  end

  def add_model(hash)
    DataMapper::Factory.build(namespace(hash), :yogo)
  end
  
  # def valid?
  #   !@project.nil?
  # end

  def project_key
    name.gsub(/[^\w]/,'')
  end

  def delete_models!
    models.each do |model|
      model.auto_migrate_down!
      name_array = model.name.split("::")
      if name_array.length == 1
        Object.send(:remove_const, model.name.to_sym)
      else
        ns = eval(name_array[0..-2].join("::"))
        ns.send(:remove_const, name_array[-1].to_sym)
      end
      DataMapper::Model.descendants.delete(model)
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
