class Membership
  include DataMapper::Resource
  include Facet::DataMapper::Resource
  
  property :project_id, UUID, :key => true

  belongs_to :project, :child_key => [:project_id], :parent_key => [:id], :model => 'Yogo::Project'
  belongs_to :role,    :key => true
  belongs_to :user,    :key => true
  
  def permissions_for(user)
    (super << "#{permission_base_name}$retrieve").uniq
  end
  
  def permissions_for(user)
    # return ["#{permission_base_name}$retrieve"] if user.nil?
    super + user.memberships(:project_id => project.id).roles.map{|r| r.actions }.flatten.uniq
  end
end