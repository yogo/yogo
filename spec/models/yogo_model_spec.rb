require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe "A Yogo Model" do
  
  before(:each) do
    @project = Project.create(:name => "Same Project")

    @properties_hash = {
      "name"    => {:type => String},
      "id"      => {:type => Integer}
    }
  end
  
  after(:each) do
    @project.destroy
  end
  
  it "should be name spaced to the project it was added to" do
    @project.add_model("Cell", @properties_hash)
    Yogo::SameProject::Cell.should_not be_nil
  end
  
  it "should have ordered columns" 
  
  describe "after Yogo::Model is included" do
  
    before(:each) do
      @model = @project.add_model("Cell", @properties_hash)
      @model.send(:include, Yogo::Model)
    end
  
    it "should have a usable_properties method" do
      @model.should respond_to(:usable_properties)
    end
    
    it "should only have 2 usable properties" do
      @model.usable_properties.length.should eql(2)
    end
  
  end
  
end