# Sample Material
#
#
class Voeis::SampleMaterial
  include DataMapper::Resource
  include Facet::DataMapper::Resource

  property :id,             Serial
  property :material,       String, :required => true, :default => 'Unknown'
  property :description,    Text,   :required => false

  property :created_at, DateTime
  property :updated_at, DateTime

  is_versioned :on => :updated_at

  has n, :samples,    :model => "Voeis::Sample", :through => Resource

end
