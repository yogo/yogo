require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))
MODEL_DEF_PATH = File.dirname(__FILE__) / 'model_definitions'

Spec::Matchers.define :be_json do
  match do |text|
    lambda { JSON.parse(text) }.should_not raise_exception
  end
end

Spec::Matchers.define :have_valid_model_id do |id_key|
  id_key ||= 'guid'
  
  match do |model_def|
    puts model_def.inspect
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

describe "Example Cell Model definition" do
  
  before(:each) do
    @cell_json = File.read(MODEL_DEF_PATH / 'Cell.json')
    #@cell_json.should be_json
    @cell_def = JSON.parse(@cell_json)
  end
  
  it "should have a guid" do
    @cell_def.should have_valid_model_id('guid')
  end
  
  it "should have an Integer property named 'Cell Class'" do
    @cell_def.should have_valid_property("Cell Class")
    @cell_def.should have_property('Cell Class', 'Integer')
  end
end

describe "A Model that supports an editing-tool," do
  
  before(:each) do
    @project = Project.create(:name => "Same Project")
    @model_name = "TestModel"
    @model = @project.add_model(@model_name)
    lambda { @model.auto_migrate! }.should_not raise_exception
    @cell_json = File.read(MODEL_DEF_PATH / 'Cell.json')
    @cell_def = JSON.parse(@cell_json)
  end
  
  after(:each) do
    @project.destroy
  end
  
  
  it "should have a guid" do
    @model.should respond_to(:guid)
    @model.guid.should == @model_name
  end
  
  it "should support converting to/from model definition format" do
    @model.should respond_to(:to_model_definition, :update_model_definition)
  end
  
  describe "that has no properties" do
    it "should convert itself to an empty model definition" do      
      new_def = @model.to_model_definition
      new_def.should have_valid_model_id('guid')
      new_def['guid'].should == @model.guid
      new_def.should_not have_property
    end
  end
  
  describe "that has properties" do
    it "should create a model definition with those properties" do      
      lambda do
        @model.instance_eval do
          property :foo, DataMapper::Types::Text, :prefix => 'yogo'
          property :bar, Integer, :prefix => 'yogo'
        end
        @model.auto_migrate!
      end.should_not raise_exception
      
      model_def = @model.to_model_definition
      #debugger
      puts model_def.inspect
      model_def.should have_valid_model_id('guid')
      model_def['guid'].should == @model.guid
      model_def.should have_property('Foo', 'Text')
      model_def.should have_property('Bar', 'Integer')
    end
  end
  
  describe "that will be updated from a model definition" do
    it "should reject a model definition without a matching guid" do
      @model.guid.should_not == "DoesNotMatch"
      lambda { @model.update_model_definition({
        "guid" => "DoesNotMatch",
        "properties" => [
          {
            "name" => "Should not exist",
            "type" => "Text",
            "options" => {}
          }
        ]
      }) }.should raise_exception
    end
  end
  
  describe "that was updated from a model definition" do
    before(:each) do
      @update_def = {
        "guid" => "TestModel",
        "properties" => [
          {"name" => "First Name",
            "type" => "Text" }
        ]
      }
      lambda { 
        @model.update_model_definition(@update_def)
      }.should_not raise_exception
    end
    
    it "should create a model definition equivalent to the original definition"
  end
  

end