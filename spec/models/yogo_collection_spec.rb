require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe "Yogo::Collection"  do
  
  before :each  do
    @yc = Yogo::Collection.new(Factory(:project))
  end
  
  it "should be invalid without a project" do
    yc = Yogo::Collection.new(nil)
    yc.should_not be_valid
  end
  
  it "should be valid with a project" do
    @yc.should be_valid    
  end
  
  it "should create a project_key from the project id and name (with non-alphas stripped)" do
    ['Test:Project, Test Project, Test&Project, Test!Project'].each do |name|
      p = Factory.create(:project, :name => name)
      key = name.gsub(/[^\w]/,'')
      p.yogo_collection.project_key.should == "#{key}"
    end
  end
  
  it "should instantiate a class of the project key" do
    @yc.project_class.should == ("Yogo::" + @yc.project_key.classify).constantize
  end
  
  describe "contains Yogo::Schemas" do

    it "should contain an array of reflected Yogo::Schema models" do
      @yc.should respond_to(:yogo_schemas)
      @yc.yogo_schemas.should_not be_nil
      @yc.yogo_schemas.should be_instance_of(Array)
      @yc.yogo_schemas.first.should be_instance_of(Yogo::Schema)
    end
    
    it "should save a valid schema and return a reflected model" do
      @json_schema = <<-EOF
      { "id":"Cell",
        "properties":{
          "name":{"type":"string"}
        }
      }
      EOF
      model = @yc.add_yogo_schema(@json_schema)
      model.should == @yc.project_class::Cell
    end
    
    it "should not save an invalid schema and return nil"
    
    it "should respond to the schemas as if it 'had many' of each"
  
  end

  
end