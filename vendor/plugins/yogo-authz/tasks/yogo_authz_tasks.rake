# desc "Explaining what the task does"
# task :yogo_ do
#   # Task goes here
# end
namespace :yogo do
  
  desc "Load Default  information."
  task :load_default_info => :environment do
    Yogo::Membership.auto_migrate!
    Yogo::Permission.auto_migrate!
    User.auto_migrate!
    Yogo::Group.auto_migrate!
    Yogo::Requirement.auto_migrate!
    
    User.create(:login => "sysadmin",
                :first_name            => "System",
                :last_name             => "Administrator",
                :email                 => "acg-support@montana.edu",
                :password              => "password",
                :password_confirmation => "password"
                )
              
    user = User.first(:login => 'sysadmin')
    
    default_group = Yogo::Group.create(:name => 'default')
    
    Yogo::Group.create(:name => Yogo::Settings[:anonymous_user_group], :foreign_id => -1)
    
    Yogo::Group.create(:parent      => default_group, 
                            :name        => 'sysadmin',
                            :description => 'User group with full administrator priviliges.',
                            :sysadmin    => true)
                            
    Yogo::Group.create(:parent      => default_group, 
                            :name        => 'committee member',
                            :description => 'committee member')
                            

    Yogo::Group.create(:parent      => default_group, 
                            :name        => 'administrator',
                            :description => 'administrator')
    
    Yogo::Membership.create(:user => user, 
                      :group => Yogo::Group.first(:name => 'sysadmin'))
  end
  
end
