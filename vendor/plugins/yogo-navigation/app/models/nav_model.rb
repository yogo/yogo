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
    if self.nav_attributes
      self.nav_attributes.each do |attribute|
        #if attribute.included
          attributes << attribute
        #end
      end
    end
    #attributes = attributes.sort
    # if has_relationships?(table)
    #   fetch_relationships(table).each_pair do |relative_table, relationship|
    #     if NavModel.first(:name => relative_table.to_s).included == true
    #       attributes << {relative_table.to_s => relationship} 
    #     end
    #   end
    # end
    #attributes << {'alpha' => 'relationship'}
    return attributes
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
