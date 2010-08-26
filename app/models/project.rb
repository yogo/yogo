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
  property :description,      Text

  property :is_private,       Boolean,    :required => true, :default => false
  property :publish_to_his,   Boolean,    :required => false, :default => false

  has n, :memberships
  has n, :users, :through => :memberships
  has n, :roles, :through => :memberships

  before :destroy, :destroy_cleanup
  after :save, :publish_his


  def self.extended_permissions
    [:manage_users, super].flatten
  end

  private
  def destroy_cleanup
    memberships.destroy
  end
  
  def publish_his
    puts "boooyah"
    if self.publish_to_his
      sites = self.managed_repository{Voeis::Site.all}
      sites.each do |site|
        system_site = Site.first(:site_code => site.code, :site_name => site.name)
        if system_site.nil? #these are function methods but aren't recognized for some reason
          system_site = Site.first_or_create(:site_code => site.code, 
                                           :site_name  => site.name,
                                           :latitude  => site.latitude, 
                                           :longitude  => site.longitude, 
                                           :lat_long_datum_id => 1,
                                           :elevation_m   => 0, 
                                           :vertical_datum  => "Unknown", 
                                           :local_x  => 0.0, 
                                           :local_y  => 0.0, 
                                           :local_projection_id  => 1,
                                           :pos_accuracy_m  => 1, 
                                           :state  => site.state, 
                                           :county  => "USA", 
                                           :comments  => "comment")
        end
        if system_site.his_id.nil?#these are function methods but aren't recognized for some reason
          his_site = His::Sites.first(:site_code => system_site.site_code)
          if !his_site.nil?
            system_site.his_id = his_site.id
          else
            site_to_store = system_site
            new_his_site = His::Sites.first_or_create(:site_code => site_to_store.site_code, 
                                             :site_name  => site_to_store.site_name,
                                             :latitude  => site_to_store.latitude, 
                                             :longitude  => site_to_store.longitude, 
                                             :lat_long_datum_id => site_to_store.lat_long_datum_id,
                                             :elevation_m   => site_to_store.elevation_m, 
                                             :vertical_datum  => "Unknown", 
                                             :local_x  => site_to_store.local_x, 
                                             :local_y  => site_to_store.local_y, 
                                             :local_projection_id  => site_to_store.local_projection_id,
                                             :pos_accuracy_m  => site_to_store.pos_accuracy_m, 
                                             :state  => site_to_store.state, 
                                             :county  => site_to_store.county, 
                                             :comments  => site_to_store.comments)
            site_to_store.his_id = new_his_site.id
            site_to_store.save
            system_site= site_to_store
          end
        end
        site.sensor_types.each do |sensor_type|
          if sensor_type.name != "Timestamp"
            variable = sensor_type.variables.first
            system_variable = Variable.first(:variable_code => variable.variable_code, :variable_name => variable.variable_name)
            if system_variable.his_id.nil?
              system_variable.store_to_his(system_variable.id)
            end
            sensor_type.sensor_values.all(:order => [:timestamp.asc]).each do |val|
              #store DataValue
              
              his_val = His::DataValues.first_or_create(:data_value => val.value,
                                    :value_accuracy => 1.0,         
                                    :local_date_time => val.timestamp,
                                    :utc_offset => 7,
                                    :date_time_utc => val.timestamp,
                                    :site_id => system_site.his_id,
                                    :variable_id => system_variable.his_id,
                                    :offset_value => 0,           
                                    :offset_type_id => 1,      
                                    :censor_code => 'nc',    
                                    :qualifier_id => 1,           
                                    :method_id => 0,              
                                    :source_id => 1,              
                                    :sample_id => 3,         
                                    #:derived_from_id => 1,        
                                    :quality_control_level_id => 0)
            end #val
          end #if
        end # sensor_type
      end #site
    end
  end

  public
  
  def self.store_site_to_system(u_id)
    site_to_store = self.managed_repository{Voeis::Site.first(:id => u_id)}
    new_system_site = Site.create(:site_code => site_to_store.code, 
                                     :site_name  => site_to_store.name,
                                     :latitude  => site_to_store.latitude, 
                                     :longitude  => site_to_store.longitude, 
                                     :lat_long_datum_id => site_to_store.lat_long_datum_id,
                                     :elevation_m   => site_to_store.elevation_m, 
                                     :vertical_datum  => site_to_store.vertical_datum, 
                                     :local_x  => site_to_store.local_x, 
                                     :local_y  => site_to_store.local_y, 
                                     :local_projection_id  => site_to_store.local_projection_id,
                                     :pos_accuracy_m  => site_to_store.pos_accuracy_m, 
                                     :state  => site_to_store.state, 
                                     :county  => site_to_store.county, 
                                     :comments  => site_to_store.comments)
  end
  # Class method for informing Project instances about what kinds of models
  # might be stored inside thier Project#managed_repository.
  #
  # @param [DataMapper::Model] model class that might be stored in Project managed_repositories
  # @return [Array<DataMapper::Model>] list of currently managed models
  def self.manage(*args)
    @managed_models ||= []
    models = args

    @managed_models += models
    @managed_models.uniq!

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
  #   managedSite = myProject.build_managed(Voeis::Site, :name => ...)
  #
  # @example Doing any of these will NOT work consistently (if at all)
  #   managedSite1 = Voeis::Site.new(:name => ...)
  #   managedSite1.save # WILL NOT save in myProject.managed_repository
  #
  #   managedSite2 = myProject.managed_repository{Voeis::Site.new(:name => ...)}
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
