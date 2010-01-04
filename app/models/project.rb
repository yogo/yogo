class Project
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :required => true

  # to_param is called by rails for routing and such
  def to_param
    id.to_s
  end
  
  # respond to #new_record for legacy purposes
  def new_record?
    new?
  end

  # A useful method
  # Mostly a joke, this can be removed.
  def puts_moo
    puts 'moo'
  end
end
