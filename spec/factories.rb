Factory.sequence :project_name do |n|
  "Test Project #{n}"
end

Factory.define :project do |p|
  p.name {Factory.next(:project_name)}
end

