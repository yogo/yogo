# SampleMediumCV
# 
# This is a "Varialble"
# The SampleMediumCV table contains the controlled vocabulary for sample media. 
# This table is pre-populated within the ODM.  Changes to this controlled vocabulary can be 
# requested at http://water.usu.edu/cuahsi/odm/. 
# 
class His::SampleMediumCV
  include DataMapper::Resource
  
  def self.default_repository_name
    :his_rest
  end
  
  def self.storage_name(repository_name)
    return self.name.gsub(/.+::/, '')
  end
  
  property :term, String, :required => true, :key => true, :field => "Term"
  property :definition, String, :field => "Definition"

  has n, :samples, :model => "His::Samples"
end