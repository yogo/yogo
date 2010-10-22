class Voeis::SamplesController < Voeis::BaseController
  # Properly override defaults to ensure proper controller behavior
  # @see Voeis::BaseController
  defaults  :route_collection_name => 'samples',
            :route_instance_name => 'sample',
            :collection_name => 'samples',
            :instance_name => 'sample',
            :resource_class => Voeis::Sample
  

  def new
    @project = parent
    @sample = parent.managed_repository{Voeis::Sample.new}
    @sample_types = SampleTypeCV.all
    @lab_methods = LabMethod.all
  end

  def edit
    @sample =  parent.managed_repository{Voeis::Sample.get(params[:id])}
    @project = parent
  end

  def create
    create! do |success, failure|
      success.html { redirect_to :action => 'new' }
    end
  end

  def upload
    
  end

  def add_sample
    @samples = Sample.all
  end

  def save_sample
    sys_sample = Sample.first(:id => params[:sample])
    parent.managed_repository{Voeis::Sample.first_or_create(
    :sample_type=> sys_sample.sample_type,         
    :lab_sample_code=> sys_sample.sample_code,
    :lab_method_id=> sys_sample.lab_method_id)}

    redirect_to project_url(parent)
  end
end
