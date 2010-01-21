# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
Dir[File.join(RAILS_ROOT, "app", "models", "**", "*.rb")].each{|f| require f}
Dir[File.join(RAILS_ROOT, "vendor", "plugins", "*", "app", "models", "**", "*.rb")].each{|f| require f}
DataMapper.auto_migrate!

begin # Yogo  initialization
  puts "Creating default user and admin group."
  User.create(:login => "default_user",
              :first_name            => "Default",
              :last_name             => "User",
              :email                 => "default_user@example.com",
              :password              => "p@55w0rd",
              :password_confirmation => "p@55w0rd"
              )
          
  user = User.first(:login => 'default_user')

  default_group = Yogo::Group.create(:name => 'default')
  
  Yogo::Group.create(:name => Yogo::Settings[:anonymous_user_group], :foreign_id => -1)

  Yogo::Group.create(:parent      => default_group, 
                          :name        => 'admin',
                          :description => 'System Administrators.',
                          :sysadmin    => true)
                        
  Yogo::Membership.create(:user => user, 
                    :group => Yogo::Group.first(:name => 'admin'))
  puts "Done"
end
