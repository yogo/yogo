
require_recipe "apt" # ensures apt cache isn't stale
require_recipe "apache2"
require_recipe "postgresql::server"
require_recipe "passenger_apache2::mod_rails"
require_recipe "rails"


# web_app "voeis" do
#   cookbook "passenger_apache2"
#   docroot "/vagrant/public"
#   server_name "voeis.#{node[:domain]}"
#   server_aliases [ "voeis", node[:hostname] ]
#   rails_env "development"
# end


