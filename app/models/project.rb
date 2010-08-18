require 'dm-core'
require 'dm-types/uuid'

require 'yogo/datamapper/repository_manager'

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
  
  def self.manage(klass)
    @managed_models ||= []
    unless @managed_models.include?(klass)
      @managed_models << klass
    end
    @managed_models
  end
  
  def self.managed_models
    @managed_models
  end
  
  
  def managed_repository_name
    ActiveSupport::Inflector.tableize(id.to_s).to_sym
  end
  
  def adapter_config
    {
      :adapter => 'sqlite',
      :database => "voeis-project-#{managed_repository_name}.db"
    }
  end
  
  def prepare_models
    adapter # ensure the adapter exists or is setup
    managed_repository.scope {
      self.class.managed_models.each do |klass|
        klass.auto_upgrade!
      end
    }
  end
  
  after :save, :prepare_models
  
  manage Voeis::Site
  manage Voeis::DataStream
  manage Voeis::DataStreamColumn
  manage Voeis::MetaTag
  manage Voeis::SensorType
  manage Voeis::SensorValue
  manage Voeis::Unit
  manage Voeis::Variable
end # Project
