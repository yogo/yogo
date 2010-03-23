Factory.sequence :project_name do |n|
  "Test Project #{n}"
end

Factory.define :project do |p|
  p.name {Factory.next(:project_name)}
end

def build_reflected_model(name, project)
  project ||= Factory.build(:project)
  factory.build(
   {:name => "#{name}",
    :modules => ["Yogo", "#{project.project_key}"],
    :properties => {
       "id"        => Serial,
       "name"      => String,
       "parent_id" => Integer
    }
   }, :default, { :attribute_prefix => "yogo" } )
end