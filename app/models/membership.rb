class Membership
  include DataMapper::Resource

  property :project_id, Integer, :key => true
  property :role_id,    Integer, :key => true
  property :user_id,    Integer, :key => true

  belongs_to :project
  belongs_to :role
  belongs_to :user
end
