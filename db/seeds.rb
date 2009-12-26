# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
Dir[File.join(RAILS_ROOT, "app", "models", "*.rb")].each{|f| require f}
Dir[File.join(RAILS_ROOT, "vendor", "plugins", "*", "app", "models", "**", "*.rb")].each{|f| require f}
DataMapper.auto_migrate!

begin # Yogo  initialization
  puts "Creating Sysadmin and supporting groups..."
  User.create(:login => "sysadmin",
              :first_name            => "System",
              :last_name             => "Administrator",
              :email                 => "yogo@montana.edu",
              :password              => "password",
              :password_confirmation => "password"
              )
          
  user = User.first(:login => 'sysadmin')

  default_group = Yogo::Group.create(:name => 'default')
  
  Yogo::Group.create(:name => Yogo::Settings[:anonymous_user_group], :foreign_id => -1)

  Yogo::Group.create(:parent      => default_group, 
                          :name        => 'sysadmin',
                          :description => 'System Administrators.',
                          :sysadmin    => true)
                        

  Yogo::Group.create(:parent      => default_group, 
                          :name        => 'pi',
                          :description => 'Principal Investigators.')

  Yogo::Group.create(:parent      => default_group, 
                          :name        => 'data_manager',
                          :description => 'Data Managers for projects.')

  Yogo::Membership.create(:user => user, 
                    :group => Yogo::Group.first(:name => 'sysadmin'))
  puts "Done"
end
