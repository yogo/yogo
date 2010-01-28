class Project
  include DataMapper::Resource
  include Yogo::Pagination
  
  property :id, Serial
  property :name, String, :required => true
  
  validates_is_unique   :name
  
  before :destroy do |project|
    self.delete_models!
  end
   
  def namespace
    name.split(/\W/).map{ |item| item.capitalize}.join("")
  end
  
  def path
    name.downcase.gsub(/[^\w]/, '_')
  end
  
  # to_param is called by rails for routing and such
  def to_param
    id.to_s
  end
  
  def process_csv(datafile)
    # Read the data in
    csv_data = FasterCSV.read(datafile.path)

    # Get Model name
    model_name = "Yogo::#{namespace}::#{File.basename(datafile.original_filename, ".csv").singularize.camelcase}"
    
    # Process the contents
    model = DataMapper::Factory.make_model_from_csv(model_name, csv_data[0..2])
    model.auto_migrate!
    
    csv_data[3..-1].each do |line| 
      line_data = Hash.new
      csv_data[0].each_index { |i| line_data[csv_data[0][i].downcase] = line[i] }
      model.create(line_data)
    end
  end

  def models
    DataMapper::Model.descendants.select { |m| m.name =~ /Yogo::#{namespace}::/ }
  end
  
  def get_model(name)
    DataMapper::Model.descendants.select{|m| m.to_s.split('::')[-1] == name }[0]
  end

  def add_model(hash)
    DataMapper::Factory.build(hash, :yogo)
  end
  
  def delete_model(model)
    model = get_model(model) if model.class == String
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

  def delete_models!
    models.each do |model|
     delete_model(model)
    end
  end
end
