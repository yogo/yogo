require 'faker'

class Yogo::Collection
  include DataMapper::Resource

  def self.default_repository_name 
    :yogo
  end
  
  # belongs_to :project
  
  property :project_id, Integer
  property :id, Serial
  
  def yogo_schema(name = nil)
    @schemas ||= []
    @schemas <<  Yogo::Schema.new('Person')
    name ? @schemas.select{|s| s.name == name}[0] : @schemas
  end
  
  def yogo_data(schema)
    yogo_schema.select{|s| s.name == schema }.first.yogo_data
  end
  
end

class Yogo::Schema
  
  attr_accessor :name

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