#
# Groups
#
class His::Group  < His::Base
  storage_names[:his] = "groups"

  property :id,       Serial
  property :value_id, Integer, :required => true

  belongs_to :group_descriptions, :model => "His::GroupDescription", :child_key => [:group_id]
  belongs_to :data_values,        :model => "His::DataValue",        :child_key => [:value_id]
end
