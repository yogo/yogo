class Membership
  include DataMapper::Resource

  property :project_id, UUID, :key => true
  property :role_id,    Integer, :key => true
  property :user_id,    Integer, :key => true

  belongs_to :project, :model => 'Yogo::Project'
  belongs_to :role
  belongs_to :user
end
