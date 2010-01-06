require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe "A Yogo::Collection" do
  
  @valid_yogo_collection = YogoCollection.new
  
  it "should return an array of schemas with #yogo_schema" do
    yc = @valid_yogo_collection
    yc.should respond_to(:yogo_schema)
    yc.yogo_schema.should_not be_nil
    yc.yogo_schema.should be_instance_of(Array)
    yc.yogo_schema.first.should be_instance_of(Yogo::Schema)
  end
  
  it "should have data for the schema" do
    yc = Yogo::Collection.new
    ys = yc.yogo_schema.first
    ys.yogo_data.should_not be_nil
    ys.yogo_data.should be_instance_of(Array)
    ys.yogo_data.length.should == 10
  end
  
  it "should save data for a schema"
  
  it "should retrieve data for a schema" do
    yc = Yogo::Collection.new
    # populate it with some data?
    yc.yogo_data('Person').length.should == 10
    
  end
  
  
end