class NavModel
  
  include DataMapper::Resource
  
  def self.default_repository_name
    :default
  end
  
  has n, :nav_attributes
  
  property :id, Serial
  property :name, String
  property :display, Boolean
  property :model_id, String
  property :display_name, String
  property :display_count, Boolean
  
  def fetch_attributes
    attributes = []
    self.nav_attributes.each do |attribute|
        attributes << attribute #if attribute.display
    end if self.nav_attributes
    return attributes.sort_by { |x| x.display.to_s }
  end
  
  def empty_contents?
    self.nav_attributes.each do |attribute|
      if !attribute.display
        return false
      end
    end
    return true
  end
  
  
end
