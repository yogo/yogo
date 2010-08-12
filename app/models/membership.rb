class Membership
  include DataMapper::Resource

  belongs_to :project, :key => true, :model => 'Yogo::Project'
  belongs_to :role,    :key => true
  belongs_to :user,    :key => true
end