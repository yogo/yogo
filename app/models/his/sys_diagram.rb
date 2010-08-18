# sysdiagrams
# 
# Doesn't appear to be associated with any other tables
#
class His::SysDiagrams
  include DataMapper::Resource
  
  def self.default_repository_name
    :his
  end
  
  def self.storage_name(repository_name)
    return self.name.gsub(/.+::/, '')
  end
  property :name, String, :required => true, :unique => true, :field => "Name" 
  property :principal_id, Integer, :required => true, :unique => true, :field => "Principal_id"
  property :diagram_id, Serial, :required => true, :key => true, :field => "DiagramID"
  property :version, Integer, :field => "Version"
  property :definition, Boolean, :field => "Definition" #VarBinary isn't support by DataMapper
  
end