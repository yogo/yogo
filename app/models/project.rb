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
  include DataMapper::Resource
  include Yogo::DataMapper::RepositoryManager
  include Facet::DataMapper::Resource

  if RUBY_VERSION == "1.8.7"
    property :id,               UUID,       :key => true, :default => lambda { UUIDTools::UUID.timestamp_create }
  else
    property :id,               UUID,       :key => true, :default => lambda { |x,y| UUIDTools::UUID.timestamp_create }
  end
  property :name,             String,     :required => true
  property :description,      Text

  property :is_private,       Boolean,    :required => true, :default => false
  property :publish_to_his,   Boolean,    :required => false, :default => false

  has n, :memberships, :parent_key => [:id], :child_key => [:project_id], :model => 'Membership'
  has n, :users, :through => :memberships
  has n, :roles, :through => :memberships

  after :create, :give_current_user_membership
  before :destroy, :destroy_cleanup
  after :save, :publish_his


  ##
  # Permissions on the object for the user that is passed in
  #
  # @param [User or nil] user To check the permissions for
  # @return [Array] Set of permissions for the current user
  # @author lamb
  # @api semipublic
  def self.permissions_for(user)
    # By default, all users can retrieve projects
    (super << "#{permission_base_name}$retrieve").uniq
  end

  ##
  # Same as above, but for instances instead of classes
  #
  # @param [User or nil] user To check permissions for
  # @return [Array] Set of permissions the current user has
  # @api semipublic
  def permissions_for(user)
    @_permissions_for ||= {}
    @_permissions_for[user] ||= begin
      base_permission = []
      # Default retrieve permissions if project is public
      base_permission += ["#{permission_base_name}$retrieve",
                          "voeis/data_stream$retrieve",
                          "voeis/data_stream_column$retrieve",
                          "voeis/meta_tag$retrieve",
                          "voeis/sensor_type$retrieve",
                          "voeis/sensor_value$retrieve",
                          "voeis/site$retrieve",
                          "voeis/unit$retrieve",
                          "voeis/variable$retrieve"] unless self.is_private?
      return base_permission if user.nil?
      (super + base_permission + user.memberships(:project_id => self.id).roles.map{|r| r.actions }).flatten.uniq
    end
  end

  def publish_his
    if self.publish_to_his
      sites = self.managed_repository{ Voeis::Site.all }
      sites.each do |site|
        # Store system wide first
        system_site = Site.first_or_create(:site_code => site.code,
                                           :site_name  => site.name,
                                           :latitude  => site.latitude,
                                           :longitude  => site.longitude,
                                           :state  => site.state,
                                           :lat_long_datum_id => 1,
                                           :elevation_m   => 0,
                                           :vertical_datum  => "Unknown",
                                           :local_x  => 0.0,
                                           :local_y  => 0.0,
                                           :local_projection_id  => 1,
                                           :pos_accuracy_m  => 1,
                                           :county  => "USA",
                                           :comments  => "comment")
        # Push to HIS
        his_site = system_site.store_to_his
        site.sensor_types.each do |sensor_type|
          if sensor_type.name != "Timestamp"
            variable = sensor_type.variables.first
            system_variable = Variable.first(:variable_code => variable.variable_code, :variable_name => variable.variable_name)
            his_variable = system_variable.store_to_his
            sensor_type.sensor_values.all(:published => false, :order => [:timestamp.asc]).each do |val|
              his_val = His::DataValue.first_or_create(:data_value => val.value,
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
              val.published = true
              val.save
            end #val
          end #if
        end # sensor_type
      end #site
    end
  end

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

  private

  def destroy_cleanup
    memberships.destroy
  end

  def give_current_user_membership
    unless User.current.nil?
      Membership.create(:user => User.current, :project => self, :role => Role.first(:position => 1))
    end
  end
end # Project
