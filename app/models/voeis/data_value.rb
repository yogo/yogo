class Voeis::DataValue
  include DataMapper::Resource
  include Facet::DataMapper::Resource
  include Yogo::Versioned::DataMapper::Resource

  property :id,                       Serial
  property :data_value,               Float,    :required => true,  :default => 0
  property :value_accuracy,           Float
  property :local_date_time,          DateTime, :required => true,  :default => DateTime.now
  property :utc_offset,               Float,    :required => true,  :default => 1.0
  property :date_time_utc,            DateTime, :required => true,  :default => DateTime.now
  property :observes_daylight_savings, Boolean, :required => true, :default => false
  property :replicate,                String,   :required => true,  :default => "original"
  property :vertical_offset,          Float, :required=>false
  property :string_value, String, :required => true, :default => "Unknown"

  yogo_versioned
  
  has n, :site,       :model => "Voeis::Site",     :through => Resource
  has 1,:source,       :model => "Voeis::Source",       :through => Resource

  has n, :sample,     :model => "Voeis::Sample",   :through => Resource
  has n, :meta_tags,  :model => "Voeis::MetaTag",  :through => Resource
  has n, :variable,   :model => "Voeis::Variable", :through => Resource
  #has n, :method,     :model => "Voeis::Method", :through => Resource
  
end
