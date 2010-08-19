class Membership
  include DataMapper::Resource
  include Facet::DataMapper::Resource
  
  property :project_id, UUID, :key => true

  belongs_to :project, :child_key => [:project_id], :parent_key => [:id], :model => 'Yogo::Project'
  belongs_to :role,    :key => true
  belongs_to :user,    :key => true
  
end