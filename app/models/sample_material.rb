# Sample Material
#
#
class SampleMaterial
  include DataMapper::Resource

  property :id,             Serial
  property :material,       String,   :required => true, :default => 'Unknown'
  property :description,    Text,   :required => false
  property :updated_at, DateTime, :required => true,  :default => DateTime.now

  is_versioned :on => :updated_at
  
  before(:save) {
    self.updated_at = DateTime.now
  }

end
