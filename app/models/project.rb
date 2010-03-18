 # Yogo Data Management Toolkit
 # Copyright (c) 2010 Montana State University
 #
 # License -> see license.txt
 #
 # FILE: project.rb
 # The project model is where the action starts.  Every yogo instance starts with a 
 # a project and the project is where the models and data will be namespaced.
 #

class Project
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String, :required => true, :unique => true
  property :description, Text, :required => false
  
  validates_is_unique   :name
  
  before :destroy, :delete_models!

  # @return [String] the project namespaced name
  #
  def namespace
    Extlib::Inflection.classify(path)
  end
  
  # @return [String] the project path name
  #
  def path
    name.downcase.gsub(/[^\w]/, '_')
  end
  
  # to_param is called by rails for routing and such
  # 
  def to_param
    id.to_s
  end
  
  # Creates a model and imports data from a CSV file
  #
  # @param datafile [string] A path to the CSV file to read in
  # @param model_name [string] the desired name of the model to be created
  #
  # * The csv datafile must be in the following format: 
  #   1. row 1 -> field names
  #   2. row 2 -> type, 
  #   3. row 3 -> units
  #   4. rows 4+ -> data
  # 
  def process_csv(datafile, model_name)
    # Read the data in
    csv_data = FasterCSV.read(datafile)

    # Look to see if there is already one of these models.
    model = get_model(model_name)

    # Process the contents

    if model.nil?
      # Get Model name
      model_name = "Yogo::#{namespace}::#{model_name}"
      model = DataMapper::Factory.instance.make_model_from_csv(model_name, csv_data[0..2])
      model.send(:include,Yogo::DataMethods) unless model.included_modules.include?(Yogo::DataMethods)
      model.auto_migrate!
      puts 'I auto migrated!'
    end
    
    # Load data
    Yogo::CSV.load_data(model, csv_data)
  end
  
  # @return [Array] of the models associated with current project namespace
  #
  def models
    DataMapper::Model.descendants.select { |m| m.name =~ /Yogo::#{namespace}::/ }
  end
  
  # @return [Model] DataMapper models name from the  "name"
  #
  # @param [name] The name of the class to retrieve
  #  
  def get_model(name)
    search_models(name).first
  end

  def search_models(search_term)
    DataMapper::Model.descendants.select{ |m| m.name =~ /Yogo::#{namespace}::\w*#{search_term}\w*/i }
  end

  # @return [DataMapper::Model] a new model 
  # Adds a model to the current project
  #
  # @param [Hash] hash contains all the modules, name and properties to define the model
  # @options hash [String] :name The models name
  # @options hash [Array] :modules An array of the modules to namespace the model
  # @options hash [Hash] :properties All the models properties
  # @options properties [Hash] prop_name This is the actual property name and is the hash-key
  # @options prop_name [String] :type The datatype of the property   
  # @options prop_name [Boolean] :required  If the property can be null or not  
  # 
  def add_model(hash_or_name, options = {})
    if hash_or_name.is_a?(String)
      return false unless valid_model_or_column_name?(hash_or_name)
      hash_or_name = {  :name => hash_or_name.camelize, 
                        :modules => ['Yogo', self.namespace],
                        :properties => options[:properties].merge({ :yogo_id => {
                                                                                  :type => DataMapper::Types::Serial,
                                                                                  :field => 'id'
                                                                                } }) 
                     }
                  
    end
    return DataMapper::Factory.instance.build(hash_or_name, :yogo)
  end
  
  # Removes a model and all of its data from a project
  #
  #
  def delete_model(model)
    model = get_model(model) if model.class == String
    name = model.name.demodulize
    model.auto_migrate_down!

    DataMapper::Model.descendants.delete(model)
    n = eval("Yogo")
    if n.constants.include?(namespace.to_sym) 
      ns = eval("Yogo::#{namespace}")
      ns.send(:remove_const, name.to_sym) if ns.constants.include?(name.to_sym)
    end
  end

  # Removes all models and all of the data from a project
  #
  # * performed before project.destroy
  def delete_models!
    models.each do |model|
      delete_model(model)
    end
  end
  
  private
  
  def valid_model_or_column_name?(potential_name)
    !potential_name.match(/^\d|\.|\!|\@|\#|\$|\%|\^|\&|\*|\(|\)/)
  end
  
end
