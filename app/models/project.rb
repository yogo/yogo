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
    name = File.basename(datafile.original_filename).sub(/[^\w\.\-]/,'_')
    file_name = File.join("tmp/data/", name)

    # Write this to a local file temporarily, this should process the contents really
    File.open(file_name, 'w') { |f| f.write(datafile.read) }
    
    # Get Model name
    model_name = "Yogo::#{project_key}::#{File.basename(file_name, ".csv").singularize.camelcase}"
    
    # Process the contents
    csv_data = FasterCSV.read(file_name)
    model = DataMapper::Factory.make_model_from_csv(model_name, csv_data[0..2])
    model.auto_migrate!
    csv_data[3..-1].each do |line| 
      line_data = Hash.new
      csv_data[0].each_index { |i| line_data[csv_data[0][i].downcase] = line[i] }
      model.create(line_data)
    end
    
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
