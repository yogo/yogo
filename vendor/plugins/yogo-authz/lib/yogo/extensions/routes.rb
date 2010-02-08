if defined?(ActionController::Routing::RouteSet)
  class ActionController::Routing::RouteSet
    def load_routes_with_yogo!
      yogo_routes = File.join(File.dirname(__FILE__),
                          %w{.. .. .. config yogo_routes.rb})
                          
      unless configuration_files.include? yogo_routes
        add_configuration_file(yogo_routes)
      end
      
      load_routes_without_yogo!
    end
  
    alias_method_chain :load_routes!, :yogo
  
  end
end
