class Voeis::Apiv
  include DataMapper::Resource
  include Facet::DataMapper::Resource
  include Yogo::Versioned::DataMapper::Resource

  property :id, Serial

  yogo_versioned
end
