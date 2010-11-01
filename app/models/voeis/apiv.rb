class Voeis::Apiv
  include DataMapper::Resource
  include Facet::DataMapper::Resource

  property :id, Serial
  property :updated_at, DateTime, :required => true,  :default => DateTime.now

  is_versioned :on => :updated_at
  
  before(:save) {
    self.updated_at = DateTime.now
  }

end