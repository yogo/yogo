class Voeis::Source
  include DataMapper::Resource
  include Facet::DataMapper::Resource
  include Yogo::Versioned::DataMapper::Resource


  property :id,                 Serial
  property :organization,       String,  :required => true                      , :format => /[^\t|\n|\r]/
  property :source_description, String,  :required => true
  property :source_link,        String
  property :contact_name,       String,  :required => true, :default => "Unkown", :format => /[^\t|\n|\r]/
  property :phone,              String,  :required => true, :default => "Unkown", :format => /[^\t|\n|\r]/
  property :email,              String,  :required => true, :default => "Unkown", :format => :email_address
  property :address,            String,  :required => true, :default => "Unkown", :format => /[^\t|\n|\r]/
  property :city,               String,  :required => true, :default => "Unkown", :format => /[^\t|\n|\r]/
  property :state,              String,  :required => true, :default => "Unkown", :format => /[^\t|\n|\r]/
  property :zip_code,           String,  :required => true, :default => "Unkown", :format => /[^\t|\n|\r]/
  property :citation,           String,  :required => true, :default => "Unkown"
  property :metadata_id,        Integer, :required => true, :default => 0

  timestamps :at
  
  yogo_versioned
  
  has n, :samples,             :model => "Voeis::Sample",           :through => Resource
  has n, :data_values,             :model => "Voeis::DataValue",           :through => Resource
  has n, :sensor_values,             :model => "Voeis::SensorValue",           :through => Resource
end