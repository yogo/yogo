# class Membership < ActiveRecord::Base
#   belongs_to :user
#   belongs_to :group
# end

class Yogo::Membership
  include DataMapper::Resource
  
  property :id,     Serial
  
  belongs_to :group, :model => 'Yogo::Group'
  belongs_to :user,  :model => 'User'
end