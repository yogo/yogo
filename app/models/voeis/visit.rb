class Voeis::Visit
  include DataMapper::Resource
  include Facet::DataMapper::Resource
  include Yogo::Versioned::DataMapper::Resource

  property :id,                  Serial
  property :date,                DateTime
  property :arrive,              DateTime
  property :depart,              DateTime
  property :description,         Text

  has n, :users, :through => Resource
  has n, :projects, :through => Resource
  has 1, :campaign, :through => Resource

  yogo_versioned
end