
##
# Check to make sure the asset directory exists and make it if it doesn't
# TODO: If the user changes the setting we should make sure that directory exists...but we don't.
if ! File.directory?(File.join(Rails.root, Setting['asset_directory']))
  FileUtils.mkdir_p(File.join(Rails.root, Setting['asset_directory']))
end

# Custom extensions for Yogo
require 'exceptions'

# Load the Application Version
load Rails.root / "VERSION"

admins = Role.first_or_create(:name => "Administrator", :description => "VOEIS system administrators.",
                                :admin => true, :project => nil)

admins.permissions = admins.available_permissions

# Role::AVAILABLE_ACTIONS.each do |action|
#   admins.add_permission(action)
# end
admins.save

if admins.users.empty?
  admins.users.create(:login => 'yogo', :email => "none", :first_name => "System",
                       :last_name => "Administrator", :password => 'change me',
                       :password_confirmation => 'change me')
  admins.save
end
