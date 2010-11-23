# Sites TODO- validate the best practices below
#
# This is a "Monitoring Site Locations"
# The Sites table provides information giving the spatial location at which data values have been
# collected.
# The following rules and best practices should be followed when populating this table:
# * The SiteID field is the primary key, must be a unique integer, and cannot be NULL.  This
# field should be implemented as an auto number/identity field.
# * The SiteCode field must contain a text code that uniquely identifies each site.  The values
# in this field should be unique and can be an alternate key for the table.  SiteCodes cannot
# contain any characters other than A-Z (case insensitive), 0-9, period “.”, dash “-“, and
# underscore “_”.
# * The LatLongDatumID must reference a valid SpatialReferenceID from the
# SpatialReferences controlled vocabulary table.  If the datum is unknown, a default value
# of 0 is used.
# * If the Elevation_m field is populated with a numeric value, a value must be specified in
# the VerticalDatum field.  The VerticalDatum field can only be populated using terms
# from the VerticalDatumCV table.  If the vertical datum is unknown, a value of
# “Unknown” is used.
# * If the LocalX and LocalY fields are populated with numeric values, a value must be
# specified in the LocalProjectionID field.  The LocalProjectionID must reference a valid
# SpatialReferenceID from the SpatialReferences controlled vocabulary table.  If the spatial
# reference system of the local coordinates is unknown, a default value of 0 is used.
#

class Voeis::Site
  include DataMapper::Resource
  include Facet::DataMapper::Resource

  property :id,                  Serial
  property :code,                String,  :required => true
  property :name,                String,  :required => true, :length => 512
  property :latitude,            Float,   :required => true
  property :longitude,           Float,   :required => true
  property :lat_long_datum_id,   Integer, :required => false, :default => 0
  property :elevation_m,         Float,   :required => false
  property :vertical_datum,      String,  :required => false
  property :local_x,             Float,   :required => false
  property :local_y,             Float,   :required => false
  property :local_projection_id, Integer, :required => false
  property :pos_accuracy_m,      Float,   :required => false
  property :state,               String,  :required => true
  property :county,              String,  :required => false
  property :comments,            Text,    :required => false
  property :description,         Text,    :required => false
  
  # repository(:default){
    property :his_id,            Integer, :required => false, :index => true
  # }
  
  property :created_at, DateTime
  property :updated_at, DateTime

  is_versioned :on => :updated_at
  
  validates_uniqueness_of :code
  
  # has n, :projects, :through => Resource
  has n, :data_streams,  :model => "Voeis::DataStream",  :through => Resource
  has n, :sensor_types,  :model => "Voeis::SensorType",  :through => Resource
  has n, :sensor_values, :model => "Voeis::SensorValue", :through => Resource
  has n, :data_values,   :model => "Voeis::DataValue",   :through => Resource
  has n, :samples,       :model => "Voeis::Sample",      :through => Resource
  has n, :variables,     :model => "Voeis::Variable",    :through => Resource
  
  alias :site_name  :name 
  alias :site_name= :name=
  
  alias :site_code  :code 
  alias :site_code= :code=
  
  def self.load_from_his
    his_sites = repository(:his){ His::Site.all }
    his_sites.each do |his_s|
      if self.first(:his_id => his_s.id).nil?
        create_from_his(his_s.id)
      end
    end
  end

  def self.create_from_his(id)
    his_s = repository(:his){ His::Site.get(id) }
    my_site = Voeis::Site.new(:his_id => his_s.id,
                       :site_code => his_s.site_code,
                       :site_name  => his_s.site_name,
                       :latitude  => his_s.latitude,
                       :longitude  => his_s.longitude,
                       :lat_long_datum_id => his_s.lat_long_datum_id,
                       :elevation_m   => his_s.elevation_m,
                       :vertical_datum  => his_s.vertical_datum,
                       :local_x  => his_s.local_x,
                       :local_y  => his_s.local_y,
                       :local_projection_id  => his_s.local_projection_id,
                       :pos_accuracy_m  => his_s.pos_accuracy_m,
                       :state  => his_s.state,
                       :county  => his_s.county,
                       :comments  => his_s.comments)
    my_site.save
  end

  def store_to_his
    new_his_site = His::Site.first_or_create(:site_code => site_code, :site_name  => site_name,
                                              :latitude  => latitude,  :longitude  => longitude,
                                              :lat_long_datum_id => lat_long_datum_id,
                                              :elevation_m   => elevation_m,
                                              :vertical_datum  => vertical_datum,
                                              :local_x  => local_x,    :local_y  => local_y,
                                              :local_projection_id  => local_projection_id,
                                              :pos_accuracy_m  => pos_accuracy_m,
                                              :state  => state,        :county  => county,
                                              :comments  => comments)
    his_id = new_his_site.id
    save
    new_his_site
  end
end