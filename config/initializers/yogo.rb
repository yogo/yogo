# Custom extensions for Yogo
require 'exceptions'

# Load the Application Version
load File.join(Rails.root.to_s, "VERSION")

##
# Check to make sure the asset directory exists and make it if it doesn't
# TODO: If the user changes the setting we should make sure that directory exists...but we don't.
if Setting['asset_directory'] && ! File.directory?(File.join(RAILS_ROOT, Setting['asset_directory']))
  FileUtils.mkdir_p(File.join(RAILS_ROOT, Setting['asset_directory']))
end
