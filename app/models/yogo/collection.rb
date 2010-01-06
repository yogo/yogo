require 'faker'

class Yogo::Collection
  include DataMapper::Resource
  include Yogo::DataStore

  def self.default_repository_name 
    :yogo
  end
  
  belongs_to :project
  
  property :id, Serial
  
  
  def yogo_schema
    @schema ||= Yogo::Schema.new('Person')
    [@schema]
  end
  
  def yogo_data(schema)
    @schema.yogo_data
  end
  
end

class Yogo::Schema

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
  def initialize
    @name = Faker::Name.name
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