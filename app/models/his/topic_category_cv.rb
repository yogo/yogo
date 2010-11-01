# TopicCategoryCV
#
# The TopicCategoryCV table contains the controlled vocabulary for the ISOMetaData topic
# categories.
# This table is pre-populated within the ODM.  Changes to this controlled vocabulary can be
# requested at http://water.usu.edu/cuahsi/odm/.
#
class His::TopicCategoryCV
  include DataMapper::Resource
  def self.default_repository_name
    :his
  end
  storage_names[:his] = "topic_category_cvs"

  property :term,       String, :required => true, :key => true, :format => /[^\t|\n|\r]/
  property :definition, String

  has n,   :ido_metadata, :model => "His::ISOMetadata"
end
