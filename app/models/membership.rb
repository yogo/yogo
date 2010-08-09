class Membership
  include DataMapper::Resource

  property :id, Serial

  belongs_to :project
  belongs_to :role
  belongs_to :user
end
