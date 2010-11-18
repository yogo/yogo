# class Site
#   include DataMapper::Resource
#   include Facet::DataMapper::Resource
# 
#   property :id,                  Serial
#   property :site_code,           String,  :required => true
#   property :site_name,           String,  :required => true,  :length => 512
#   property :latitude,            Float,   :required => true
#   property :longitude,           Float,   :required => true
#   property :state,               String,  :required => true
#   property :lat_long_datum_id,   Integer, :required => false, :default => 0
#   property :elevation_m,         Float,   :required => false
#   property :vertical_datum,      String,  :required => false
#   property :local_x,             Float,   :required => false
#   property :local_y,             Float,   :required => false
#   property :local_projection_id, Integer, :required => false
#   property :pos_accuracy_m,      Float,   :required => false
#   property :county,              String,  :required => false
#   property :comments,            Text,    :required => false
# 
#   timestamps :at
# 
#  
# 
#   is_versioned :on => :updated_at
# 
#   has n, :data_streams, :model => "Voeis::DataStream", :through => Resource
#   has n, :sensor_types,    :model => "Voeis::SensorType", :through => Resource
#   has n, :sensor_values,  :model => "Voeis::SensorValue", :through => Resource
#   has n, :data_values,  :model => "Voeis::DataValue", :through => Resource
#   has n, :samples,  :model => "Voeis::Sample", :through => Resource
#   has n, :variables, :model => "Voeis::Variable", :through => Resource
# 
# 
# end