class Project
  include DataMapper::Resource

  property :id, Serial
  property :name, String


  def to_param
    id.to_s
  end
  
  def new_record?
    new?
  end

  # A useful method
  def puts_moo
    puts 'moo'
  end
end
