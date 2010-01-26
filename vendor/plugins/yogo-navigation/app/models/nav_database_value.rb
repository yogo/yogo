class NavDatabaseValue
  
  include DataMapper::Resource
  
  def self.default_repository_name
    :default
  end
  
  belongs_to :nav_display_value

  property :id, Serial
  property :value, String
  
end