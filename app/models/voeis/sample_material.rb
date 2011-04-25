# Sample Material
#
#
class Voeis::SampleMaterial
  include DataMapper::Resource
  include Facet::DataMapper::Resource
  include Yogo::Versioned::DataMapper::Resource

  property :id,             Serial
  property :material,       String, :required => true, :default => 'Unknown'
  property :description,    Text,   :required => false

  yogo_versioned

  has n, :samples, :model => "Voeis::Sample", :through => Resource

end
