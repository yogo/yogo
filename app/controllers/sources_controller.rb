require 'responders/rql'

class SourcesController < InheritedResources::Base
  rescue_from ActionView::MissingTemplate, :with => :invalid_page
  responders :rql
  defaults  :route_collection_name => 'sources',
            :route_instance_name => 'source',
            :collection_name => 'sources',
            :instance_name => 'source',
            :resource_class => Voeis::Source

  respond_to :html, :json
  
  # GET /sources/new
  def new
    @source = Voeis::Source.new
    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  # POST /sources
  def create

    @source = Voeis::Source.new(params[:source])
    respond_to do |format|
      if @source.save
        flash[:notice] = 'Sources was successfully created.'
        format.json do
          render :json => @source.as_json, :callback => params[:jsoncallback]
        end
        format.html { (redirect_to(source_path( @source.id))) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # def show
  #   respond_to do |format|
  #     format.json do
        
  #     end
  #   end
  # end
  


  def invalid_page
    redirect_to(:back)
  end
end
