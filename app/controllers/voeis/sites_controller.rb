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
    @sites = Site.all
    
  end
  
  def save_site
    sys_site = Site.first(:id => params[:site])
    parent.managed_repository{Voeis::Site.first_or_create(
                :site_code => sys_site.site_code,
                :site_name => sys_site.site_name,
                :latitude => sys_site.latitude,
                :longitude  => sys_site.longitude,
                # :lat_long_datum_id => sys_site.lat_long_datum_id,
                # :elevation_m => sys_site.elevation_m,
                # :vertical_datum => sys_site.vertical_datum,
                # :local_x => sys_site.local_x,
                # :local_y => sys_site.local_y,
                # :local_projection_id => sys_site.local_projection_id,
                # :pos_accuracy_m => sys_site.pos_accuracy_m,
                :state => sys_site.state)}
                # :county => sys_site.county,
                # :comments => sys_site.comments)}
    redirect_to project_url(parent)
  end
end
