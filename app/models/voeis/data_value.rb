class Voeis::DataValue
  include DataMapper::Resource
  include Facet::DataMapper::Resource

  property :id,                       Serial
  property :data_value,               Float,    :required => true,  :default => 0
  property :value_accuracy,           Float
  property :local_date_time,          DateTime, :required => true,  :default => DateTime.now
  property :utc_offset,               Float,    :required => true,  :default => 1.0
  property :date_time_utc,            DateTime, :required => true,  :default => DateTime.now 
  property :replicate,                String,   :required => true,  :default => "original"
  property :updated_at, DateTime, :required => true,  :default => DateTime.now

  is_versioned :on => :updated_at
  
  before(:save) {
    self.updated_at = DateTime.now
  }
  
  # property :site_id,                  Integer,  :required => true,  :default => 1
  # property :variable_id,              Integer,  :required => true,  :default => 1
  # property :offset_value,             Float
  # property :offset_type_id,           Integer
  # property :censor_code,              String,   :required => true,  :default => 'nc'
  # property :qualifier_id,             Integer
  # property :method_id,                Integer,  :required => true,  :default => 0
  # property :source_id,                Integer,  :required => true,  :default => 1
  # property :sample_id,                Integer
  # property :derived_from_id,          Integer
  # property :quality_control_level_id, Integer,  :required => true,  :default => -9999
  
  has n, :site,       :model => "Voeis::Site", :through => Resource
  has n, :sample,     :model => "Voeis::Sample", :through => Resource
  has n, :meta_tags,  :model => "Voeis::MetaTag", :through => Resource
  has n, :variable,   :model => "Voeis::Variable", :through => Resource
  #has n, :method,     :model => "Voeis::Method", :through => Resource
  
end