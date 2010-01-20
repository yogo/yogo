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
      p.yogo_collection.project_key.match(/[^\w]/).should be_nil
    end
  end
  
  describe "contains references to reflected datamapper models" do

    it "should contain an array of reflected models" do
      @yc.should respond_to(:models)
      @yc.models.should_not be_nil
      @yc.models.should be_instance_of(Array)
      @yc.models.each do |m|
        m.should be_instance_of(DataMapper::Property)
      end
    end
    
    it "should respond to an add_model method that creates a model" do
      collection = Yogo::Collection.new(Factory(:project, :name => 'Test Project 1'))
      model_hash = { 
        "id" => "Yogo/TestProject1/Cell",
        "properties" => {
          "name" => {"type" => "string"}
        }
      }
      m = collection.add_model(model_hash)
      m.should == Yogo::TestProject1::Cell
      Yogo::TestProject1::Cell.ancestors.should include(DataMapper::Resource)
    end
    
    it "should make the newly added model available via .models" do
      model_hash = { 
        "id" => "Yogo/#{@yc.project_key}/Cell",
        "properties" => {
          "name" => {"type" => "string"}
        }
      }
      @yc.add_model(model_hash)
      model_names = @yc.models.map(&:name)
      model_names.map{|m| m.match(/^Yogo::#{@yc.project_key}::Cell/)}.compact.should_not be_empty
    end
    
    
    it "should properly namespace an un-namespaced model hash" do
      model_hash = { 
        "id" => "Monkey",
        "properties" => {
          "name" => {"type" => "string"}
        }
      }
      @yc.add_model(model_hash)
      model_names = @yc.models.map(&:name)
      model_names.map{|m| m.match(/^Yogo::#{@yc.project_key}::Monkey/)}.compact.should_not be_empty
    end
    
    it "should save a valid schema which should be persisted to the datastore" do
      # This is already in the test database and should be pre-populated for 
      # the above project
      persisted_model_hash = { 
        "id" => "Yogo/PersistedData/Cell",
        "properties" => {
          "name" => {"type" => "string"}
        }
      }
      repository(:yogo).adapter.put_schema(persisted_model_hash)
      project = Factory(:project, :name => 'Persisted Data')
      project.yogo_collection.models.should be_empty
      DataMapper::Reflection.create_all_models_from_database
      project.yogo_collection.models.should_not be_empty
    end
    
    it "should be able to delete its schemas" do
      persisted_model_hash = { 
        "id" => "Yogo/PersistedData/Cell",
        "properties" => {
          "name" => {"type" => "string"}
        }
      }
      repository(:yogo).adapter.put_schema(persisted_model_hash)
      project = Factory(:project, :name => 'Persisted Data')
      project.yogo_collection.models.should_not be_empty
      project.yogo_collection.delete_models!
      project.yogo_collection.models.should be_empty
    end
    
    it "should not save an invalid schema and return nil"
    
    it "should respond to the schemas as if it 'had many' of each"
  
  end

  
end