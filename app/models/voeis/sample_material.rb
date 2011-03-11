# Sample Material
#
#
class Voeis::SampleMaterial
  include DataMapper::Resource
  include Facet::DataMapper::Resource

  property :id,             Serial
  property :material,       String, :required => true, :default => 'Unknown'
  property :description,    Text,   :required => false

  timestamps :at
  
  is_versioned :on => :updated_at

  has n, :samples, :model => "Voeis::Sample", :through => Resource

end
