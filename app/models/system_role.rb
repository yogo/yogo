class SystemRole
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String, :required => true
  property :description, String
  property :permissions, Yaml, :default => [].to_yaml
  
  has n, :users
end