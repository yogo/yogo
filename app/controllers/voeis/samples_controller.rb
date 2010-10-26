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
    @sample = @project.managed_repository{Voeis::Sample.new}
    @sample_types = SampleTypeCV.all
    @sample_materials = SampleMaterial.all
    @sites = @project.managed_repository{Voeis::Site.all}
    @lab_methods = LabMethod.all
  end

  def edit
    @sample =  parent.managed_repository{Voeis::Sample.get(:params[:id])}
    @project = parent
  end

  def create
    parent.managed_repository do
      @sample = Voeis::Sample.new(:sample_type =>   params[:sample][:sample_type],
                                  :material => params[:sample][:material],
                                  :lab_sample_code => params[:sample][:lab_sample_code],
                                  :lab_method_id => params[:sample][:lab_method_id].to_i)
                                  
      puts @sample.valid?
      puts @sample.errors.inspect()
      if @sample.save   
        @sample.sites << Voeis::Site.get(params[:site].to_i)
        @sample.save
        flash[:notice] = 'Sample was successfully created.'
        redirect_to :action => 'new'
      end
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
