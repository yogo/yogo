class YogoProject
  include DataMapper::Resource

  @@basename = "Yogo"

  property :id, Serial
  property :name, String, :nullable => false
  property :prefix, String, :nullable => false
  property :created_at, DateTime
  property :updated_at, DateTime

  #
  # Override this so when a name is set the prefix is generated.
  #

  def name=(new_name)
    attribute_set(:name, new_name)
    temp_name = new_name.gsub(" ", "")
    attribute_set(:prefix, [@@basename, temp_name].join("_"))
  end
end

