# Sites TODO- validate the best practices below

class Site
  include DataMapper::Resource
  
  property :id, Serial
  property :his_id, Integer, :required => false
  property :site_code, String, :required => true
  property :site_name, String, :required => true, :length => 512
  property :latitude, Float, :required => true
  property :longitude, Float, :required => true
  property :lat_long_datum_id, Integer, :required => false, :default => 0
  property :elevation_m, Float, :required => false
  property :vertical_datum, String, :required => false
  property :local_x, Float,  :required => false
  property :local_y, Float, :required => false
  property :local_projection_id, Integer, :required => false
  property :pos_accuracy_m, Float, :required => false
  property :state, String, :required => true
  property :county, String, :required => false
  property :comments, String, :required => false, :length => 512

  def self.update_from_his
    his_sites = His::Sites.all
    his_sites.each do |his_s|
      if self.first(:his_id => his_s.id).nil?
        new_site = self.new(:his_id => his_s.id,
                    :site_code => his_s.site_code, 
                    :site_name  => his_s.site_name,
                    :latitude  => his_s.latitude, 
                    :longitude  => his_s.longitude, 
                    :lat_long_datum_id => his_s.lat_long_datum_id,
                    :elevation_m   => his_s.elevation_m, 
                    :vertical_datum  => his_s.vertical_datum, 
                    :local_x  => his_s.local_x, 
                    :local_y  => his_s.local_y, 
                    :local_projection_id  => his_s.local_projection_id,
                    :pos_accuracy_m  => his_s.pos_accuracy_m, 
                    :state  => his_s.state, 
                    :county  => his_s.county, 
                    :comments  => his_s.comments)
        new_site.save
        if !new_site.errors.nil?
          puts new_site.errors.inspect
        end
      end
    end
  end
  
  def self.store_his_site(id)
    his_s = His::Sites.get(id)
    my_site = Site.new(:his_id => his_s.id,
                :site_code => his_s.site_code, 
                :site_name  => his_s.site_name,
                :latitude  => his_s.latitude, 
                :longitude  => his_s.longitude, 
                :lat_long_datum_id => his_s.lat_long_datum_id,
                :elevation_m   => his_s.elevation_m, 
                :vertical_datum  => his_s.vertical_datum, 
                :local_x  => his_s.local_x, 
                :local_y  => his_s.local_y, 
                :local_projection_id  => his_s.local_projection_id,
                :pos_accuracy_m  => his_s.pos_accuracy_m, 
                :state  => his_s.state, 
                :county  => his_s.county, 
                :comments  => his_s.comments)
    my_site.save
    if !my_site.errors.nil?
      puts my_site.errors.inspect
    end
  end
    
    
    
  
  #probably don't want to do it this way 
  #probably want to use self but my brain is blanking 
  #so I'm writing it this way for now in the name of speed
  def self.store_to_his(u_id)
    site_to_store = self.first(:id => u_id)
    new_his_site = His::Sites.create(:site_code => site_to_store.site_code, 
                                     :site_name  => site_to_store.site_name,
                                     :latitude  => site_to_store.latitude, 
                                     :longitude  => site_to_store.longitude, 
                                     :lat_long_datum_id => site_to_store.lat_long_datum_id,
                                     :elevation_m   => site_to_store.elevation_m, 
                                     :vertical_datum  => site_to_store.vertical_datum, 
                                     :local_x  => site_to_store.local_x, 
                                     :local_y  => site_to_store.local_y, 
                                     :local_projection_id  => site_to_store.local_projection_id,
                                     :pos_accuracy_m  => site_to_store.pos_accuracy_m, 
                                     :state  => site_to_store.state, 
                                     :county  => site_to_store.county, 
                                     :comments  => site_to_store.comments)
    site_to_store.his_id = new_his_site.id
    site_to_store.save
  end
end