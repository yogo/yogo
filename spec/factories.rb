Factory.sequence :project_name do |n|
  "Test Project #{n}"
end

Factory.define :project do |p|
  p.name {Factory.next(:project_name)}
end

def build_reflected_model(name, project)
  project ||= Factory.build(:project)
  DataMapper::Factory.build(
  {'id' => "Yogo/#{project.project_key}/#{name}",
    'properties' => {
      "name"      => 'string',
      'parent_id' => 'integer'
    }
  })
  
end