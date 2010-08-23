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

# Create the system administrator user
User.create(:login => 'yogo', :email => "nobody@home.com", :first_name => "System",
            :last_name => "Administrator", :admin => true,
            :password => 'change me', :password_confirmation => 'change me')

# Load/create users (from a file?)
User.create(:login => 'test', :email => "test@user.org", :first_name => "Test", :last_name => "User",
            :password => "VOEISdude", :password_confirmation => "VOEISdude")

