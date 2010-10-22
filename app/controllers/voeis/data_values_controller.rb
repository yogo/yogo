class Voeis::DataValuesController < Voeis::BaseController
  
  # Properly override defaults to ensure proper controller behavior
  # @see Voeis::BaseController
  defaults  :route_collection_name => 'data_values',
            :route_instance_name => 'data_value',
            :collection_name => 'data_values',
            :instance_name => 'data_value',
            :resource_class => Voeis::DataValue
  
  
  def pre_process
    @project = parent
    @general_categories = GeneralCategoryCV.all
  end
  
  def pre_upload
  
  end
end
