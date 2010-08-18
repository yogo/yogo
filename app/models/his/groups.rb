# Groups
#

# 
class His::Groups
  include DataMapper::Resource
  include Odhelper
  
  def self.default_repository_name
    :his
  end
  
  def self.storage_name(repository_name)
    return self.name.gsub(/.+::/, '')
  end
  
  property :id,       Integer, :required => true, :field => "GroupID", :key => true
  property :value_id, Integer, :required => true, :field => "ValueID"

  belongs_to :group_descriptions, :model => "His::GroupDescriptions", :child_key => [:group_id] 
  belongs_to :data_values,        :model => "His::DataValues",        :child_key => [:value_id] 

end