class NavDisplayValue
  
  include DataMapper::Resource

  def self.default_repository_name
    :default
  end
  
  belongs_to :nav_attribute
  has 1, :nav_database_value
  
  property :id, Serial
  property :value, String
  
end
