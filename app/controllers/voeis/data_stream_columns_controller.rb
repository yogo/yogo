class Voeis::DataStreamColumnsController < Voeis::BaseController
  
  # Properly override defaults to ensure proper controller behavior
  # @see Voeis::BaseController
  defaults  :route_collection_name => 'data_stream_columns',
            :route_instance_name => 'data_stream_column',
            :collection_name => 'data_stream_columns',
            :instance_name => 'data_stream_column',
            :resource_class => Voeis::DataStreamColumn
  

end
