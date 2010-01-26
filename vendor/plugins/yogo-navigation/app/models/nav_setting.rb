class NavSetting
  
  include DataMapper::Resource
  
  def self.default_repository_name
    :default
  end
  
  property :id, Serial
  property :root_name, String
  
end
