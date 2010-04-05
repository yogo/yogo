 # Yogo Data Management Toolkit
 # Copyright (c) 2010 Montana State University
 #
 # License -> see license.txt
 #
 # FILE: project.rb
 # The project model is where the action starts.  Every yogo instance starts with a 
 # a project and the project is where the models and data will be namespaced.
 #

# Class for a Yogo Project. A project contains a name, a description, and access to all of the models
# that are part of the project.
class Project
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String, :required => true, :unique => true
  property :description, Text, :required => false
  
  validates_is_unique   :name
  
  before :destroy, :delete_models!
  ##
  # Returns the namespace Yogo Models will be in
  # 
  # @example
  #   my_project.namespace 
  # 
  # @return [String] 
  #   the project namespaced name
  # 
  # @author Yogo Team
  #
  # @api public
  #
  def namespace
    Extlib::Inflection.classify(path)
  end
  
  ##
  # Used to get the current project path name
  #
  # @return [String] the project path name
  #
  # @author Yogo Team
  #
  # @api private
  #
  def path
    name.downcase.gsub(/[^\w]/, '_')
  end
  ##
  # Compatability method for rails' route generation helpers
  #
  # @return [String] the object id as url param
  #
  # @author Yogo Team
  #
  # @api private
  #
  def to_param
    id.to_s
  end
  
  ##
  # Creates a model and imports data from a CSV file
  #
  # @example 
  #    "aproject.process_csv('mydata.csv','MyModel')"  
  #    loading data from a CSV file into a project model
  #
  # @param [String] datafile 
  #   A path to the CSV file to read in
  # @param [String] model_name 
  #   The desired name of the model to be created
  #
  # @return [Array] 
  #   Returns empty array if successful or an array of error messages if unsuccessful
  #
  # * The csv datafile must be in the following format: 
  #   1. row 1 -> field names
  #   2. row 2 -> type, 
  #   3. row 3 -> units
  #   4. rows 4+ -> data
  # 
  # @author Robbie Lamb
  # 
  # @api public
  #
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
  
  ##
  # Returns all of the Yogo::Models assocated with the project
  # 
  # @example
  #  models
  #
  # @return [Array] 
  #   All of the models associated with current project namespace
  #
  # @author
  #
  # @api public
  #
  def models
    DataMapper::Model.descendants.select { |m| m.name =~ /Yogo::#{namespace}::/ }
  end
  
  ##
  # Used to retreive the DataMapper model by it's name
  #
  # @example
  #  get_model("SampleModel")
  #
  # @param [String] name
  #  The name of the class to retrieve
  #
  # @return [Model] the DataMapper model
  #
  # @author Yogo Team
  #
  # @api public
  #  
  def get_model(name)
    DataMapper::Model.descendants.select{ |m| m.name =~ /^Yogo::#{namespace}::#{name}$/i }[0]
  end

  
  def search_models(search_term)
    DataMapper::Model.descendants.select{ |m| m.name =~ /^Yogo::#{namespace}::\w*#{search_term}\w*$/i }
  end

  ##
  # Adds a model to the current project
  #
  # @example
  #  add_model("CDs")
  #
  # @param [Hash or String] hash_or_name contains all the modules, name and properties to define the model
  # @option hash_or_name [String] :name 
  #  The models name
  # @option hash_or_name [Array] :modules 
  #  An array of the modules to namespace the model
  # @option hash_or_name [Hash] :properties 
  #  All the models properties
  # @option properties [Hash] prop_name 
  #  This is the actual property name and is the hash-key
  # @option prop_name [String] :type 
  #  The datatype of the property   
  # @option prop_name [Boolean] :required  
  #  If the property can be null or not
  # @param [Hash] options
  #  contains an addtional hash of the properties - used if the hash_or_name parameter is a "String"
  # @option properties [Hash] prop_name 
  #   This is the actual property name and is the hash-key
  # @option prop_name [String] :type 
  #  The datatype of the property   
  # @option prop_name [Boolean] :required  
  #  If the property can be null or not 
  #
  # @return [DataMapper::Model] a new model 
  #
  # @author Yogo Team
  #
  # @api public
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
  
  ##
  # Removes a model and any data contianed with from a project
  #
  # @example
  #  delete_model("CDs")
  #
  # @param [String] model
  #  the name of the model to delete
  #
  # @return [Boolean] return True if model removed successfully
  #
  # @author Yogo Team
  #
  # @api public
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
  
  ##
  # Removes all models and all of the data from a project
  #
  # @example 
  #  delete_models!
  #
  # @return [Boolean] returns True if all models removed successfully
  #
  # @author Yogo Team
  #
  # @api public
  #
  def delete_models!
    models.each do |model|
      delete_model(model)
    end
  end
  
  private
  
  ##
  # The name to check for validity
  #
  # @param [String] potential_name
  # 
  # @return [TrueClass or FalseClass]
  #  If the string passed in can be a valid model or colum name
  # 
  # @author Yogo Team
  #
  # @api private
  #
  def valid_model_or_column_name?(potential_name)
    !potential_name.match(/^\d|\.|\!|\@|\#|\$|\%|\^|\&|\*|\(|\)/)
  end
  
  ##
  # Generates a model with the property :yogo_id in the project's namespace
  #
  # It will not be automigrated
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
  #
  def generate_empty_model(model_name)
    spec_hash = { :modules => ["Yogo", namespace],
                  :name => model_name, 
                  :properties => { 'yogo_id' => {:type => DataMapper::Types::Serial, :field => 'id' }}
                }

    model = DataMapper::Factory.instance.build(spec_hash, :yogo, { :attribute_prefix => "yogo" } )
    model.send(:include,Yogo::Model)
    
  end
  
end
