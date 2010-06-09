require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper'))

MODEL_DEF_PATH = File.expand_path(File.join(File.dirname(__FILE__))) unless defined?(MODEL_DEF_PATH)
require MODEL_DEF_PATH / 'matchers'

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