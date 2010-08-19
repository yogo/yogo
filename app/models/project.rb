require 'dm-core'
require 'dm-types/uuid'

require 'yogo/datamapper/repository_manager'

# Top-level data-management container.
#
# Project includes functionality from Yogo::DataMapper::RespositoryManager
# @see http://github.com/yogo/yogo-project/blob/topic/managers/lib/yogo/datamapper/repository_manager.rb
#
# 
class Project
  include ::DataMapper::Resource
  include Yogo::DataMapper::RepositoryManager

  property :id,               UUID,       :key => true, :default => lambda { UUIDTools::UUID.timestamp_create }
  property :name,             String,     :required => true
  property :description,      String
  
  property :is_private,      Boolean, :required => true, :default => false

  has n, :memberships
  has n, :users, :through => :memberships
  has n, :roles, :through => :memberships

  before :destroy, :destroy_cleanup

  def self.extended_permissions
    collection_perms = [ :create_models, :retrieve_models, :update_models, :delete_models, :create_data, :retrieve_data, :update_data, :delete_data ]
    [:manage_users, collection_perms, super].flatten
  end

  private
  def destroy_cleanup
    memberships.destroy
  end
  
  public
  
  # Class method for informing Project instances about what kinds of models
  # might be stored inside thier Project#managed_repository.
  # 
  # @param [DataMapper::Model] model class that might be stored in Project managed_repositories
  # @return [Array<DataMapper::Model>] list of currently managed models
  def self.manage(*args)
    @managed_models ||= []
    models = args
    
    @managed_models += models
    @monaged_models.uniq!
    
    @managed_models
  end
  
  # Models that are currently managed by Project instances.
  # @return [Array<DataMapper::Model>] list of currently managed models
  def self.managed_models
    @managed_models
  end
  
  # Ensure that Relation models are also managed
  def self.finalize_managed_models!
    models = []
    @managed_models.each do |m|
      models += m.relationships.values.map{|r| r.child_model }
      models += m.relationships.values.map{|r| r.parent_model }
    end
    @managed_models += models
    @managed_models.uniq!
    @managed_models
  end
  
  # @author Ryan Heimbuch
  # 
  # Override required from Yogo::DataMapper::Repository#managed_repository_name
  # 
  # @return [Symbol] the name for the DataMapper::Repository that the Project manages
  def managed_repository_name
    ActiveSupport::Inflector.tableize(id.to_s).to_sym
  end
  
  # @author Ryan Heimbuch
  # 
  # @return [Hash] The adapter configuration for the Project managed_repository
  # @see DataMapper.setup
  # @todo Refactor this method into a module in yogo-project
  def adapter_config
    {
      :adapter => 'sqlite',
      :database => "db/sqlite3/voeis-project-#{managed_repository_name}.db"
    }
  end
  
  # Ensure that models that models managed by the Project
  # are properly migrated/upgraded inside the Project managed repository.
  #
  # @author Ryan Heimbuch
  # @todo Refactor this method into a module in yogo-project
  def prepare_models
    adapter # ensure the adapter exists or is setup
    managed_repository.scope {
      self.class.finalize_managed_models!
      self.class.managed_models.each do |klass|
        klass.auto_upgrade!
      end
    }
  end
  
  # Builds a "new", unsaved datamapper resource, that is explicitly
  # bound to the Project#managed_repository. 
  # If you want to create a new resource that will be saved inside the
  # repository of a Project, you should always use this method.
  # 
  # @example Create a new site that is stored in myProject.managed_repository
  #   managedSite = myProject.build_managed(Voeis::Site, :site_name => ...)
  #
  # @example Doing any of these will NOT work consistently (if at all)
  #   managedSite1 = Voeis::Site.new(:site_name => ...)
  #   managedSite1.save # WILL NOT save in myProject.managed_repository
  #
  #   managedSite2 = myProject.managed_repository{Voeis::Site.new(:site_name => ...)}
  #   managedSite2.save # WILL NOT save in myProject.managed_repository
  #
  # Boring Details:
  #   Initially "new" model resources do not bind themselves to any repository.
  #   At some point a "new" resource will persist itself and bind itself exclusively
  #   to the repository that it "persisted into". This step is fiddly to catch, and 
  #   happens deep inside the DataMapper code. It is MUCH easier to explictly bind
  #   the "new" resource to a particular repository immediately after calling #new.
  #   This requires using reflection to modify the internal state of the resource object,
  #   so it is best sealed inside a single method, rather than scattered throughout 
  #   the codebase.
  #
  # @todo Refactor into module in yogo-project
  # @author Ryan Heimbuch
  def build_managed(model_klass, attributes={})
    unless self.class.managed_models.include? model_klass
      self.class.manage(model_klass)
      prepare_models
    end
    res = model_klass.new(attributes)
    res.instance_variable_set(:@_repository, managed_repository)
    res
  end
  
  # Ensure that models that we might store in the Project#managed_repository
  # are properly migrated/upgrade whenever the Project changes.
  # @author Ryan Heimbuch
  # @see Project#prepare_models
  after :save, :prepare_models
  
  # Ensure that our common Voeis models are ready to be persisted
  # in the Project#managed_repository.
  # @author Ryan Heimbuch
  manage Voeis::Site
  manage Voeis::DataStream
  manage Voeis::DataStreamColumn
  manage Voeis::MetaTag
  manage Voeis::SensorType
  manage Voeis::SensorValue
  manage Voeis::Unit
  manage Voeis::Variable
end # Project
