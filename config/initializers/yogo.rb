##
# Check to make sure the asset directory exists and make it if it doesn't
# TODO: If the user changes the setting we should make sure that directory exists...but we don't.
if ! File.directory?(File.join(Rails.root, Yogo::Setting['asset_directory']))
  FileUtils.mkdir_p(File.join(Rails.root, Yogo::Setting['asset_directory']))
end

# Custom extensions for Yogo
require 'exceptions'

# Load the Application Version
load Rails.root / "VERSION"

sr = SystemRole.first_or_new(:name => 'User', :description => 'Default user in the system')
sr.actions = ["yogo/project$retrieve"] and sr.save if sr.new?
sr.move(:to => 1)

sr = SystemRole.first_or_new(:name => 'Project Manager', :description => 'Able to create projects')
sr.actions = ["yogo/projects$retrieve", "yogo/projects$update"] and sr.save if sr.new?
sr.move(:to => 2)

sr = SystemRole.first_or_new(:name => 'Administrator', :description => 'System role for Administrators')
sr.actions = SystemRole.available_permissions and sr.save if sr.new?
sr.move(:to => 3)

# Create the system administrator user
User.create(:login => 'yogo', :first_name => "System",
            :last_name => "Administrator", :system_role => sr,
            :password => 'change me', :password_confirmation => 'change me') if User.find_by_login('yogo').nil?
            
# Default Yogo Roles, we always want the PI to be in position 1
Role.first_or_create(:name => "Principal Investigator", :description => "Principal Investigators create projects to pursue research goals.").move(:to => 1)
# Role.first_or_create(:name => "Field Technician",       :description => "Field Technicians manage field activities.")
# Role.first_or_create(:name => "Laboratory Technician",  :description => "Lab Technicians manage lab activities.")
Role.first_or_create(:name => "Data Manager",           :description => "Data Managers manage all the data for a project.").move(:to => 2)
Role.first_or_create(:name => "Member",                 :description => "General members of projects.").move(:to => 3)