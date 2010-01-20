require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe "A Factory" do
  
  it "should exist" do
    DataMapper::Factory.should_not be_nil
  end
  
  it "should respond to create_model_from_json_schema" do
    DataMapper::Factory.should respond_to(:describe_model_from_json_schema)
    # Factory.should respond_to(:build)
  end

  it "should respond to build" do
    DataMapper::Factory.should respond_to(:build)
  end
  
end