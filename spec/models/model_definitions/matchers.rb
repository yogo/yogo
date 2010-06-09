Spec::Matchers.define :be_json do
  match do |text|
    lambda { JSON.parse(text) }.should_not raise_exception
  end
end

Spec::Matchers.define :have_valid_model_id do |id_key|
  id_key ||= 'guid'
  
  match do |model_def|
    model_def.should have_key(id_key)
    id = model_def[id_key]
    id.should_not be_nil
    id.should be_kind_of(String)
  end
  
  failure_message_for_should do |model_def|
    "The model definition does not have a valid #{id_key}: #{model_def.inspect}"
  end
  
  failure_message_for_should_not do |model_def|
    "The model definition has a valid id!"
  end
  
  description do
    "Test a model definition for a valid id."
  end
end

Spec::Matchers.define :have_property do |name, type|
  name = name || ".*"
  type = type || ".*"
  
  match do |model_def|
    properties = model_def['properties']
    properties.should_not be_nil
    properties.should be_kind_of(Array)
    properties.should_not be_empty
    
    properties.find do |p| 
      (Regexp.new(name) =~ p['name']) && (Regexp.new(type) =~ p['type'])
    end
  end
  
  failure_message_for_should do |model_def|
    "Model definition DOES NOT have a property with (name: #{name}, type: #{type})"
  end
  
  failure_message_for_should_not do |model_def|
    "Model definition HAS a property with (name: #{name}, type: #{type})"
  end
  
  description do
    "Check for a property in a model definition."
  end
end

Spec::Matchers.define :have_valid_prop_type do
  match do |prop|
    type = prop['type']
    type.should be_kind_of(String)
    type.should_not be_empty
    Yogo::Types.human_types.should include(type)
  end
  
  failure_message_for_should do |prop|
    "Model property #{prop['name']} has invalid type: #{prop['type']}."
  end
  
  description do
    "Check that a model property is a valid property type."
  end
end

Spec::Matchers.define :have_valid_property do |name|
  match do |model_def|
    model_def.should have_property(name)
    prop = model_def['properties'].find {|p| p['name'] == name }
    prop.should_not be_nil
    prop.should have_valid_prop_type
  end
  
  failure_message_for_should do |model_def|
    "Model definition has invalid property: #{name}"
  end
  
  description do
    "Verify that a model has a named property that is valid."
  end
end