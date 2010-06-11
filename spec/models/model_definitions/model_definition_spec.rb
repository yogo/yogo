require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper'))

MODEL_DEF_PATH = File.expand_path(File.join(File.dirname(__FILE__))) unless defined?(MODEL_DEF_PATH)
require MODEL_DEF_PATH / 'matchers'



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