class His::Base
  include DataMapper::Resource
  
  def self.default_repository_name
    :his
  end
end
