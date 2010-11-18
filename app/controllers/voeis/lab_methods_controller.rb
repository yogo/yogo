class Voeis::LabMethodsController < Voeis::BaseController
  # Properly override defaults to ensure proper controller behavior
  # @see Voeis::BaseController
  defaults  :route_collection_name => 'lab_methods',
            :route_instance_name => 'lab_method',
            :collection_name => 'lab_methods',
            :instance_name => 'lab_method',
            :resource_class => Voeis::LabMethod

  def new
    @project = parent
    @lab_methods = Voeis::LabMethod.all
  end

  def edit
    @lab_method =  parent.managed_repository{Voeis::LabMethod.get(params[:id])}
    @project = parent
  end

  def create
    parent.managed_repository do
      if params[:lab_method].nil?
        @lab_method = Voeis::LabMethod.new(:lab_name=> params[:lab_name], :lab_organization => params[:lab_organization], :lab_method_name => params[:lab_method_name], :lab_method_description => params[:lab_method_description])
      else
        @lab_method = Voeis::LabMethod.new(params[:lab_method])
      end
      respond_to do |format|
        if @lab_method.save
          flash[:notice] = 'Lab Method was successfully created.'
          format.html { (redirect_to(new_project_lab_method_path())) }
          format.js
        else
          format.html { render :action => "new" }
        end
      end
    end
  end

  def add_lab_method
    @lab_methods = Voeis::LabMethod.all
  end

  def save_lab_method
    sys_lab_method = Voeis::LabMethod.first(:id => params[:lab_method])
    parent.managed_repository{Voeis::LabMethod.first_or_create(
      :lab_name => sys_lab_method.lab_name,         
      :lab_organization=> sys_lab_method.lab_organization,
      :lab_method_name=> sys_lab_method.lab_method_name,
      :lab_method_description=> sys_lab_method.lab_method_description,
      :lab_method_link=> sys_lab_method.lab_method_link)}

    redirect_to project_url(parent)
  end
end
