class NavAttribute
  
  include DataMapper::Resource
  
  def self.default_repository_name
    :default
  end
  
  belongs_to :nav_model
  has n, :nav_display_values
  
  property :id, Serial
  property :name, String
  property :display, Boolean
  property :display_name, String
  property :display_count, Boolean
  property :range, Boolean
  
  def fetch_range_display
    names = []
    self.nav_display_values.each do |display|
      names << display.value
    end
    return (names.sort) << '+'
  end
  
  def fetch_db_value(range)
    self.nav_display_values.first(:value => range).nav_database_value.value
  end
  
end
