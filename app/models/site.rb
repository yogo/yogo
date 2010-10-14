class Site
  include DataMapper::Resource

  property :id,                  Serial
  property :site_code,           String,  :required => true
  property :site_name,           String,  :required => true,  :length => 512
  property :latitude,            Float,   :required => true
  property :longitude,           Float,   :required => true
  property :state,               String,  :required => true
  property :his_id,              Integer, :required => false
  property :lat_long_datum_id,   Integer, :required => false, :default => 0
  property :elevation_m,         Float,   :required => false
  property :vertical_datum,      String,  :required => false
  property :local_x,             Float,   :required => false
  property :local_y,             Float,   :required => false
  property :local_projection_id, Integer, :required => false
  property :pos_accuracy_m,      Float,   :required => false
  property :county,              String,  :required => false
  property :comments,            String,  :required => false, :length => 512

  def self.load_from_his
    his_sites = His::Site.all
    his_sites.each do |his_s|
      if self.first(:his_id => his_s.id).nil?
        create_from_his(his_s.id)
      end
    end
  end

  def self.create_from_his(id)
    his_s = His::Site.get(id)
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
  end

  def store_to_his
    new_his_site = His::Site.first_or_create(:site_code => site_code, :site_name  => site_name,
                                              :latitude  => latitude,  :longitude  => longitude,
                                              :lat_long_datum_id => lat_long_datum_id,
                                              :elevation_m   => elevation_m,
                                              :vertical_datum  => vertical_datum,
                                              :local_x  => local_x,    :local_y  => local_y,
                                              :local_projection_id  => local_projection_id,
                                              :pos_accuracy_m  => pos_accuracy_m,
                                              :state  => state,        :county  => county,
                                              :comments  => comments)
    his_id = new_his_site.id
    save
    new_his_site
  end
end