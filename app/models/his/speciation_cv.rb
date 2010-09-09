# SpeciatonCV
#
# The SpeciationCV table contains the controlled vocabulary for the Speciation field in the 
# Variables table. 
# This table is pre-populated within the ODM.  Changes to this controlled vocabulary can be 
# requested at http://water.usu.edu/cuahsi/odm/. 
# 
class His::SpeciationCV
  include DataMapper::Resource
  include Odhelper
 
  def self.default_repository_name
    :his_rest
  end
  
  def self.storage_name(repository_name)
    return self.name.gsub(/.+::/, '')
  end
 
  property :term, String, :required => true, :key => true, :field => "Term"
  property :definition, String, :field => "Definition"
  
  has n, :variables, :model => "His::Variables"
  
  validates_with_method :term, :method => :check_term
  def check_term
    check_ws_absence(self.term, "Term")
  end
end