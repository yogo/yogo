# ODMVersion
# 
# DThe ODM Version table has a single record that records the version of the ODM database.  This 
# table must contain a valid ODM version number.  This table will be pre-populated and should 
# not be edited. 
# 
class His::ODMVersion
  include DataMapper::Resource
  
  def self.default_repository_name
    :his_rest
  end
  
  def self.storage_name(repository_name)
    return self.name.gsub(/.+::/, '')
  end
  
  property :version_number, String, :required => true, :key =>true, :field => "VersionNumber"
end