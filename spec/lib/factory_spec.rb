require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe "A Factory" do
  
  it "should create a model from a valid hash" do
    valid_hash = { :name => 'Bacon',
                   :properties => {
                     :id => 'Serial',
                     :fat_content => 'Float',
                     :hickory_smoked => { 'type' => 'Boolean', 'default' => false }
                   }}
                   
    bacon_model = DataMapper::Factory.build_model_from_hash(valid_hash)

    bacon_model.should_not be_nil
    bacon_model.should respond_to(:auto_migrate!)
    bacon_model.should respond_to(:auto_migrate_up!)
    bacon_model.should respond_to(:auto_migrate_down!)
  end
  
  it "should exist" do
    DataMapper::Factory.should_not be_nil
  end
  
  it "should respond to create_model_from_json_schema" do
    DataMapper::Factory.should respond_to(:describe_model_from_json_schema)
  end

  it "should respond to build" do
    DataMapper::Factory.should respond_to(:build)
  end
  
end