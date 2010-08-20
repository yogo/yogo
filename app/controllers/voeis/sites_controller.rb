class Voeis::SitesController < Voeis::BaseController
  # Properly override defaults to ensure proper controller behavior
  # @see Voeis::BaseController
  defaults  :route_collection_name => 'sites',
            :route_instance_name => 'site',
            :collection_name => 'sites',
            :instance_name => 'site',
            :resource_class => Voeis::Site

  def create
    # This should be handled by the framework, but isn't when using jruby.
    params[:site][:latitude] = params[:site][:latitude].strip
    params[:site][:longitude] = params[:site][:longitude].strip

    create! do |success, failure|
      success.html { redirect_to project_url(parent) }
    end
  end
  
  def add_site
    @sites = His::Sites.all
    
  end
  
  def save_site
    his_site = His::Sites.first(:id => params[:site])
    parent.managed_repository{Voeis::Site.first_or_create(
                :site_code => his_site.site_code,
                :site_name => his_site.site_name,
                :latitude => his_site.latitude,
                :longitude  => his_site.longitude,
                # :lat_long_datum_id => his_site.lat_long_datum_id,
                # :elevation_m => his_site.elevation_m,
                # :vertical_datum => his_site.vertical_datum,
                # :local_x => his_site.local_x,
                # :local_y => his_site.local_y,
                # :local_projection_id => his_site.local_projection_id,
                # :pos_accuracy_m => his_site.pos_accuracy_m,
                :state => his_site.state)}
                # :county => his_site.county,
                # :comments => his_site.comments)}
    redirect_to project_url(parent)
  end
end
