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
  
  describe "contains reflected datamapper models" do

    it "should contain an array of reflected Yogo::Schema models" do
      @yc.should respond_to(:yogo_schemas)
      @yc.yogo_schemas.should_not be_nil
      @yc.yogo_schemas.should be_instance_of(Hash)
      @yc.yogo_schemas.each do |ys|
        ys.should be_instance_of(DataMapper::Property)
      end
    end
    
    it "should save a valid schema and return a reflected model" do
      @json_schema = <<-EOF
      { "id":"Cell",
        "properties":{
          "name":{"type":"string"}
        }
      }
      EOF
      model = @yc.add_yogo_schema(@json_schema)[0]
      model.class.should == DataMapper::Property
      model.model.should == @yc.project_class::Cell
    end

    it "should save a valid schema which should be persisted to the datastore" do
      project = Factory(:project)
      @json_schema = <<-EOF
      { "id":"Cell",
        "properties":{
          "name":{"type":"string"}
        }
      }
      EOF
      model_name = project.yogo_collection.add_yogo_schema(@json_schema)[0].model.name
      project_id = project.id
      project = nil # remove any references to that project, GC should happen
      project = Project.get project_id
      project.yogo_collection.yogo_schemas.should_not be_empty
      project.yogo_collection.yogo_schemas[model_name].should_not be_nil
    end        

    it "should load and reflect pre-existing schemas" # do
    #       
    #     end
    
    it "should not save an invalid schema and return nil"
    
    it "should respond to the schemas as if it 'had many' of each"
  
  end

  
end