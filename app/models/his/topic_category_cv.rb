# TopicCategoryCV
#
# The TopicCategoryCV table contains the controlled vocabulary for the ISOMetaData topic 
# categories.   
# This table is pre-populated within the ODM.  Changes to this controlled vocabulary can be 
# requested at http://water.usu.edu/cuahsi/odm/. 
# 
class His::TopicCategoryCV
  include DataMapper::Resource
  include Odhelper
  
  def self.default_repository_name
    :his
  end
  
  def self.storage_name(repository_name)
    return self.name.gsub(/.+::/, '')
  end
  
  property :term, String, :required => true, :key => true, :field => "Term"
  property :definition, String, :field => "Definition"

  has n, :ido_metadata, :model => "His::ISOMetadata"
  
  validates_with_method :term, :method => :check_term
  def check_term
    check_ws_absence(self.term, "Term")
  end
end