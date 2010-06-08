# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: project.rb
# The project model is where the action starts.  Every yogo instance starts with a 
# a project and the project is where the models and data will be namespaced.

# Class for a Yogo Project. A project contains a name, a description, and access to all of the models
# that are part of the project.
class Project
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String, :required => true, :unique => true
  property :description, Text, :required => false
  property :public, Boolean, :required => true, :default => true
  
  validates_is_unique   :name
  
  before :destroy, :delete_models!
  
  after :create, :create_default_groups
  
  has n, :groups
  
  # The number of items to be displayed (by default) per page
  # 
  # @return [Fixnum]
  # 
  # @api public
  def self.per_page
    15
  end
  
  ##
  # Returns all projects that have been marked public
  # 
  # @example
  #   Project.public
  # 
  # @return [DataMapper::Collection]
  # 
  # @author lamb
  # 
  # @api public
  def self.public(opts = {})
    all( opts.merge({:public => true}) )
  end
  
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
  # @example
  #   @project.path
  # 
  # @return [String] the project path name
  #
  # @author Yogo Team
  #
  # @api semipublic
  def path
    name.downcase.gsub(/[^\w]/, '_')
  end

  ##
  # Compatability method for rails' route generation helpers
  #
  # @example
  #   @project.to_param # returns the ID as a string
  # 
  # @return [String] the object id as url param
  #
  # @author Yogo Team
  #
  # @api public
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
  def process_csv(datafile, model_name)
    
    model_name = model_name.gsub(/\s/,'_').classify
    
    # Look to see if there is already one of these models.
    model = get_model(model_name)

    # Generate a model with no properties.
    if model.nil?
      model = generate_empty_model(model_name)
      model.auto_migrate!
    end
    
    # Load data
    errors = model.load_csv_data(datafile)
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

  ##
  # Used to retreive the DataMapper model that have search term in their name
  #
  # @example
  #  search_models("Baccon")
  #
  # @param [String] search_term
  #  The term to search for
  #
  # @return [Models] the DataMapper models
  #
  # @author Yogo Team
  #
  # @api public
  #
  def search_models(search_term)
    DataMapper::Model.descendants.select{ |m| m.name =~ /^Yogo::#{namespace}::\w*#{search_term}\w*$/i }
  end

  ##
  # Adds a model to the current project
  #
  # @example
  #  add_model("CDs")
  #
  # @param [String] name the name of the model to be created
  # @param [Hash] properties Each key in the property is a new property name. The key points to an 
  #     options hash for the property. The key 'type' is required. All other keys are optional and
  #     the same as a normal datamapper property options hash. 
  # 
  #
  # @return [DataMapper::Model] a new model 
  #
  # @author Robbie Lamb robbie.lamb@gmail.com
  #
  # @see http://datamapper.org/docs/properties
  # 
  # @api public
  def add_model(name, properties = {})
    name = name.classify
    return false unless valid_model_or_column_name?(name)

    a_model = generate_empty_model(name)
    
    properties.each do |name, options|
      a_model.send(:property, name, options.delete(:type), options.merge(:prefix => 'yogo'))
    end

    a_model.backup_schema!

    return a_model
  end
  
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
  
  ##
  # Reloads the models for this schema from the backups
  # @return [Array]
  #   An array of models that have been refreshed
  #
  # @author robbie.lamb@gmail.com
  # @api private
  def reload_schemas_from_backup!
    models.each do |m|
      sb = SchemaBackup.get_or_create_by_name(m.name.to_s) 
      repository.adapter.update_schema(JSON.parse(sb.schema))
    end
    
    models.each do |model|
      namespace_parts = model.name.split("::")
      name = namespace_parts.pop
      namespace = namespace_parts.join("::")
      
      DataMapper::Model.descendants.delete(model)
      namespace.constantize.send(:remove_const, name.to_sym)
    end
    
    new_models = DataMapper::Reflection.reflect(:default)

    new_models.each{|m| m.send(:include,Yogo::Model) }
    new_models.each{|m| m.properties.sort! }
  end
  
  ## 
  # Return the description for a dataset
  # 
  # @param [String] dataset name
  # 
  # @return [String or Nil]
  # 
  # @author Pol Llovet pol.llovet@gmail.com
  # 
  def dataset_description(dataset)
    "Directionally selective mechanosensory afferents in the cricket cercal sensory system form a map of air current direction in the terminal abdominal ganglion. The global organization of this map was revealed by studying the anatomical relationships between an ensemble of sensory afferents that represented the entire range of receptor hair directional sensitivities on the sensory epithelium. The shapes and three-dimensional positions of the terminal arborizations of these cells were highly conserved across animals. Afferents with similar directional sensitivities arborized near each other within the map, and their terminal arborizations showed significant anatomical overlap. There was a clear global organization pattern of afferents within the map: they were organized into a spiral shape, with stimulus direction mapped continuously around the spiral. These results demonstrate that this map is not formed via a direct point-to-point topographic projection from the sensory epithelium to the CNS. Rather, the continuous representation of air current direction is synthesized within the CNS via an anatomical reorganization of the afferent terminal arbors. The arbors are reorganized according to a functional property that is independent of the location of the mechanoreceptor in the epithelium. The ensemble data were used to derive predictions of the patterns of steady-state excitation throughout the map for different directional stimuli. These images represent quantitative and testable predictions of functional characteristics of the entire neural map."
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
  def generate_empty_model(model_name)
    spec_hash = { :modules => ["Yogo", namespace],
                  :name => model_name, 
                  :properties => { 
                    'yogo_id' => {
                      :type => DataMapper::Types::Serial, 
                      :field => 'id' 
                      },
                      :created_at => {
                        :type => DateTime 
                      },
                      :updated_at => {
                        :type => DateTime
                      },
                      :created_by_id => {
                        :type => Integer
                      },
                      :updated_by_id => {
                        :type => Integer
                      },
                      :change_summary => {
                        :type => Text
                      }
                    }
                }

    model = DataMapper::Factory.instance.build(spec_hash, :yogo )
    model.send(:include,Yogo::Model)
    return model
  end
  
  def create_default_groups
    DataMapper.logger.debug { "Creating default groups" }
    manager_group = Group.new(:name => 'managers')
    user_group = Group.new(:name => 'users')
    manager_group.users << User.current unless User.current.nil?
    # manager_group.save
    self.groups.push( manager_group, user_group )
    # owner_group.save
    self.save
  end
  
end

# require 'project_observer'
  
# class ProjectObserver
#   include DataMapper::Observer
#   
#   observe Project
#   
#   before :save do
#     puts 'This is before a save of some sort!'
#   end
#   
#   before :add_model do
#     puts 'This should raise an error.'
#     raise AuthorizationError, "You can't do that!"
#   end
#   
#   before :destroy do
#     raise AuthorizationError, "You can't do that!"
#   end
#   
#   before :delete_model do
#     raise AuthorizationError, "You can't do that!"
#   end
#   
#   before :delete_models! do
#     raise AuthorizationError, "You can't do that!"
#   end
# end
