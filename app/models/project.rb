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
  property :is_public, Boolean, :required => true, :default => true
  
  validates_uniqueness_of   :name
  
  before :destroy, :delete_models!
  before :destroy, :delete_associated_groups!
  
  after :create, :create_default_groups
  
  has n, :groups
  
  # The number of items to be displayed (by default) per page
  # 
  # @example
  #   Project.per_page
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
    all( opts.merge({:is_public => true}) )
  end
  
  ##
  # Returns all private projects the current user has access to
  # 
  # @example
  #   Project.private
  # 
  # @return [DataMapper::Collection or nil]
  # 
  # @author lamb
  # 
  # @api public
  def self.private(opts = {})
    current_user = User.current
    return nil if current_user.nil?
    # all( opts.merge( :is_public => false ) ).select{|p| current_user.is_in_project?(p) }
    current_user.groups.projects(opts)
  end
  
  ##
  # Returns all projects the current user has access to
  # 
  # @example
  #   Project.available
  # 
  # @return [DataMapper::Collection or Array]
  # 
  # @author lamb
  # 
  # @api public
  def self.available(opts = {})
    return self.all(opts) if Yogo::Setting[:local_only]
    # else
    private_projects = self.private
    if private_projects == nil
      self.public(opts)
    else
      (self.public + self.private).all(opts)
    end
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
    path.classify
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
  def add_model(name, properties = {}, relationships = {})
    name = name.classify
    return false unless valid_model_or_column_name?(name)

    a_model = generate_empty_model(name)
    
    properties.each do |name, options|
      a_model.send(:property, name, options.delete(:type), options.merge(:prefix => 'yogo'))
    end

    relationships.each do |name, options|
      # Do something for each one
    end

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
  # @example
  #   project.dataset_description('blah')
  # 
  # @param [String] dataset 
  #   The description
  # 
  # @return [String or Nil]
  # 
  # @author Pol Llovet pol.llovet@gmail.com
  # 
  # @api public
  def dataset_description(dataset)
    "There should be a dataset description, make the editor."
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
                      :type => DataMapper::Property::Serial, 
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
  
  ##
  # Callback to create some default groups for this project
  # 
  # @return [nil]
  # @author Robbie Lamb
  # @api private
  def create_default_groups
    DataMapper.logger.debug { "Creating default groups" }

    manager_group = Group.new(:name => 'Manager')
    manager_group.users << User.current unless User.current.nil?

    view_project = Group.new(:name => 'View Project')
    edit_project = Group.new(:name => 'Edit Project')
    edit_model   = Group.new(:name => 'Edit Models')
    edit_data    = Group.new(:name => 'Edit Data')
    delete_data  = Group.new(:name => 'Delete Data')
    self.groups.push( manager_group, view_project, edit_project, edit_model, edit_data, delete_data )
    self.save
    [:edit_project, :edit_model_descriptions, :edit_model_data, :delete_model_data].each do |action|
      manager_group.add_permission(action)
    end
    manager_group.save
    view_project.add_permission(:view_project)
    view_project.save
    edit_project.add_permission(:edit_project)
    edit_project.save
    edit_model.add_permission(:edit_model_descriptions)
    edit_model.save
    edit_data.add_permission(:edit_model_data)
    edit_data.save
    delete_data.add_permission(:delete_model_data)
    delete_data.save
    
  end
  
  def delete_associated_groups!
    self.groups.each{|g| g.destroy }
  end
  
end
