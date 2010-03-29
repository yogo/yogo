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
  # @api private
  def path
    name.downcase.gsub(/[^\w]/, '_')
  end
  
  # @return [String] the object id as url param
  # @api private
  def to_param
    id.to_s
  end
  
  # Creates a model and imports data from a CSV file
  #
  # @param [String] datafile 
  #   A path to the CSV file to read in
  # @param [String] model_name 
  #   The desired name of the model to be created
  #
  # @return [Array] 
  #   Returns empty array if successful or an array of error messages if unsuccessful.
  #
  # * The csv datafile must be in the following format: 
  #   1. row 1 -> field names
  #   2. row 2 -> type, 
  #   3. row 3 -> units
  #   4. rows 4+ -> data
  # 
  #  @example loading data from a CSV file into a project model
  #    "aproject.process_csv('mydata.csv','MyModel')"
  # 
  # @author Robbie Lamb
  # 
  # @api public
  def process_csv(datafile, model_name)
    # Read the data in
    csv_data = FasterCSV.read(datafile)
    
    # Look to see if there is already one of these models.
    model = get_model(model_name)

    # Generate a model with no properties.
    if model.nil?
      model = generate_empty_model(model_name)
      model.auto_migrate!
    end
    
    # Load data
    errors = model.load_csv_data(csv_data)
    return errors
  end
  
  # @return [Array] of the models associated with current project namespace
  # @api private, semipublic, or public
  def models
    DataMapper::Model.descendants.select { |m| m.name =~ /Yogo::#{namespace}::/ }
  end
  
  # @return [Model] DataMapper models name from the  "name"
  # @param [name] The name of the class to retrieve
  #  
  def get_model(name)
    DataMapper::Model.descendants.select{ |m| m.name =~ /^Yogo::#{namespace}::#{name}$/i }[0]
  end

  
  def search_models(search_term)
    DataMapper::Model.descendants.select{ |m| m.name =~ /^Yogo::#{namespace}::\w*#{search_term}\w*$/i }
  end

  # @return [DataMapper::Model] a new model 
  # Adds a model to the current project
  #
  # @param [Hash] hash contains all the modules, name and properties to define the model
  # @option hash [String] :name The models name
  # @option hash [Array] :modules An array of the modules to namespace the model
  # @option hash [Hash] :properties All the models properties
  # @option properties [Hash] prop_name This is the actual property name and is the hash-key
  # @option prop_name [String] :type The datatype of the property   
  # @option prop_name [Boolean] :required  If the property can be null or not  
  # 
  def add_model(hash_or_name, options = {})
    if hash_or_name.is_a?(String)
      return false unless valid_model_or_column_name?(hash_or_name)
      hash_or_name = {  :name => hash_or_name.camelize, 
                        :modules => ['Yogo', self.namespace],
                        :properties => options[:properties].merge(
                          { :yogo_id => {
                              :type => DataMapper::Types::Serial,
                              :field => 'id'
                            } 
                        }) 
                     }
                  
    end
    return DataMapper::Factory.instance.build(hash_or_name, :yogo, { :attribute_prefix => "yogo" })
  end
  
  # @return [String] Removes a model and all of its data from a project
  # @api public
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

  # @return [Model] Removes all models and all of the data from a project
  # @api public
  def delete_models!
    models.each do |model|
      delete_model(model)
    end
  end
  
  private
  
  # @param [String] potential_name
  #   The name to check for validity.
  # 
  # @return [TrueClass or FalseClass]
  #  If the string passed in can be a valid model or colum name
  # 
  # @api private
  def valid_model_or_column_name?(potential_name)
    !potential_name.match(/^\d|\.|\!|\@|\#|\$|\%|\^|\&|\*|\(|\)/)
  end
  
  # Generated a model with the only property being :yogo_id in this project's namespace.
  # It will not be automigrated.
  # 
  # @param [String] name
  #   The name to give to the class.
  # 
  # @return [Class]
  #   The class that has been generated.
  #
  # @author Robbie Lamb robbie.lamb@gmail.com
  # 
  # @api private
  def generate_empty_model(model_name)
    spec_hash = { :modules => ["Yogo", namespace],
                  :name => model_name, 
                  :properties => { 'yogo_id' => {:type => DataMapper::Types::Serial, :field => 'id' }}
                }

    model = DataMapper::Factory.instance.build(spec_hash, :yogo, { :attribute_prefix => "yogo" } )
    model.send(:include,Yogo::Model)
    
  end
  
end
