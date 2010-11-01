#
# Groups
#
class His::Group 
  include DataMapper::Resource
  def self.default_repository_name
    :his
  end
  storage_names[:his] = "groups"

  property :id,       Serial
  property :value_id, Integer, :required => true

  belongs_to :group_descriptions, :model => "His::GroupDescription", :child_key => [:group_id]
  belongs_to :data_values,        :model => "His::DataValue",        :child_key => [:value_id]
end
