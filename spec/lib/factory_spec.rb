require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe "A Factory" do
  
  before(:all) do
    @factory = DataMapper::Factory.instance()
    @valid_hash = { :name => 'Bacon',
                   :modules => [],
                   :properties => {
                     :yogo_id => { :type => DataMapper::Types::Serial, :field => 'id' },
                     :fat_content => Float,
                     :hickory_smoked => { :type => DataMapper::Types::Boolean, :default => false }
                   }}
  end
  
  it "should exist" do
    @factory.should_not be_nil
  end
  
  it "should be a singleton" do
    @factory.should === DataMapper::Factory.instance()
  end
  
  it "should respond to build" do
    @factory.should respond_to(:build)
  end
  
  it "should create a model from a valid hash" do
    bacon_model = @factory.build(@valid_hash)

    bacon_model.should_not be_nil
    bacon_model.should respond_to(:auto_migrate!)
    bacon_model.should respond_to(:auto_migrate_up!)
    bacon_model.should respond_to(:auto_migrate_down!)
    bacon_model.properties.each do |prop|
      @valid_hash[:properties].keys.should include(prop.name)
    end
  end
    
  it "should make a model from a properly formatted csv file"

end