class Voeis::UnitsController < Voeis::BaseController
  
  # Properly override defaults to ensure proper controller behavior
  # @see Voeis::BaseController
  defaults  :route_collection_name => 'units',
            :route_instance_name => 'unit',
            :collection_name => 'units',
            :instance_name => 'unit',
            :resource_class => Voeis::Unit

end
