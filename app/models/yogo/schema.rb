class Yogo::Schema 
  

  def self.default_repository_name 
    :yogo
  end

  def initialize(name)
    @name = name
    @data = []
    10.times do 
      @data << Yogo::Data.new
    end
  end
  
  def yogo_data
    @data
  end

  def to_s
    @name
  end

  def to_json
    {
      :name => @name,
      :data => @data
    }.to_json
  end
  
  
end



class Yogo::Data
  
  def self.default_repository_name 
    :yogo
  end
  
  def initialize
    @name = "Faker::Name.name"
  end
  
  def to_s
    @name
  end
  
  def attributes
    [:name, :id]
  end
  
  def to_json
    {:name => @name}.to_json
  end
end