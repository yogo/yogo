class Voeis::Apiv
  include DataMapper::Resource
  include Facet::DataMapper::Resource

  property :id, Serial

  timestamps :at

  is_versioned :on => :updated_at
  
end
