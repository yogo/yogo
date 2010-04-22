# Yogo

require File.dirname(__FILE__) + '/yogo/extensions/routes'
require File.dirname(__FILE__) + '/yogo/extensions/exceptions'
require File.dirname(__FILE__) + '/yogo/yogo_user'
require File.dirname(__FILE__) + '/yogo/authenticated_system'
require File.dirname(__FILE__) + '/yogo/authorization_system'
require File.dirname(__FILE__) + '/yogo/controller_helpers'
require File.dirname(__FILE__) + '/yogo/authlogic_dm/compatability'

# TODO: Play with these load paths for gem usage.
# %w{ models controllers }.each do |dir|
#   path = File.join(File.dirname(__FILE__), 'app', dir, 'yogo')
#   puts path
#   $LOAD_PATH << path
#   ActiveSupport::Dependencies.load_paths << path
#   ActiveSupport::Dependencies.load_once_paths.delete(path)
# end