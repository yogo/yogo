class Feedback
  include DataMapper::Resource
  include Facet::DataMapper::Resource

  property :id, Serial
  property :user, String, :required => true
  property :url, String, :required => true 
  property :issue, Text, :required => true

end