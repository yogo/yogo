require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

def mock_uploader(file, type = 'text/csv')
  filename = "%s/%s" % [ File.dirname(__FILE__), file ]
  uploader = ActionController::UploadedStringIO.new
  uploader.original_path = filename
  uploader.content_type = type
  def uploader.read
    File.read(original_path)
  end
  def uploader.size
    File.stat(original_path).size
  end
  uploader
end

describe Project do
  
  before(:each) do
    Project.all.destroy!
    Group.all.destroy!
    User.all.destroy!
    User.current = nil
  end
  
  after(:each) do
    User.current = nil
  end
  
  it "should not be created without a name" do
    count = Project.all.length
    p = Project.new
    p.should_not be_valid   
    p.save
    count.should == Project.all.length
  end
  
  it "should be created with a name" do
    count = Project.all.length
    p = Project.new(:name => "Test Original Name")
    p.should be_valid
    p.save
    count.should == Project.all.length - 1
  end
  
  it "should have a unique name" do
    count = Project.all.length
    p = Project.create(:name => "Same Project")
    p.should be_valid
    q = Project.new(:name => "Same Project")
    q.should_not be_valid
    q.errors.on(:name).should_not be_empty
    q.save.should be_false
    Project.all.length.should == count+1
  end
  
  it "should respond to to_param with the id as a string" do
    p = Project.create(:name => "Test Project")
    p.to_param.should == p.id.to_s
  end
  
  it "should create a namespace from the project id and name (with non-alphas stripped)" do
    ['Test:Project', 'Test Project', 'Test&Project', 'Test!Project'].each do |name|
      p = Project.create(:name => name)
      p.namespace.match(/[^\w]/).should be_nil
      p.destroy!
    end
  end
  
  it "should be paginated" do
    Project.should respond_to(:page_count)
    Project.should respond_to(:paginate)
  end
  
  it "should be created with a set of default groups" do
    p = Project.new(:name => 'blah', :is_public => false)
    p.save
  
    p.groups.should_not be_empty
    Project.first(:name => 'blah').groups.should_not be_empty
    p.destroy
    Group.all.destroy
  end

  it "should be by default a public project" do
    Project.create(:name => 'A Project').is_public.should be_true
  end

  it "should not return private projects when .public is called" do
    p1 = Project.create(:name => 'test project 1')
    p2 = Project.create(:name => 'test project 2')
    p3 = Project.create(:name => 'test project 3')
    pp = Project.create(:name => 'Private project', :is_public => false)

    Project.public.should_not include(pp)
  end
  
  it "should have 5 groups" do
    p = Project.create(:name => 'test project')

    group_names = Project.first.groups.map(&:name)
    group_names.should include('Manager')
    group_names.should include('Edit Project')
    group_names.should include('Edit Models')
    group_names.should include('Edit Data')
    group_names.should include('Delete Data')
    group_names.length.should eql 5
    p.destroy
    Group.all.destroy
  end
  
  it "should create 5 groups on save" do
    p = Project.new(:name => 'a test project')
    p.save
    
    group_names = Project.first.groups.map(&:name)
    group_names.length.should eql 5
    p.destroy
    Group.all.destroy
  end
  
  it "should set a logged in user to belong to the 'manager' group" do
    u = standard_user
    user_login = u.login
    u.save

    User.current = u
    
    p = Project.create(:name => 'test project')

    Project[0].groups.all(:name => 'Manager').users.length.should eql 1
    
    Project[0].groups.all(:name => 'Manager').users[0].login.should eql user_login

    User.current = nil
    p.destroy
    Group.all.destroy
    User.all.destroy
  end

  describe "searching" do
    it "should be searchable" do
      Project.should respond_to(:search)
    end
    
    it "should search for a project by a name" do
      Project.create(:name  => "Searchable Name")
      Project.search('Name').length.should == 1
    end
    
    it "should search with spaces" do
      Project.create(:name => "A Long Name")
      Project.search('A Long Name').length.should == 1
    end
    
  end
  
  it "should process a csv file" do
    file_name = "#{SPEC_ROOT}/models/csv/csvtest.csv"
    p = Project.create(:name => "CSV Test Project")
    p.process_csv(file_name, 'Csvtest').should be_empty
    results = p.search_models('csvtest')
    results.should be_an Array
    results.length.should eql(1)
    results[0].name.should eql("Yogo::#{p.namespace}::Csvtest")
    p.delete_models!
    
  end
  
  it "should not process a bad csv file" do
    file_name = "#{SPEC_ROOT}/models/csv/bad_csvtest.csv"
    p = Project.create(:name => "Bad CSV Test Project")
    errors = p.process_csv(file_name, 'Csvtest')
    errors.should_not be_empty
    p.delete_models!
  end
  
  # This test fails if you do the following:
  # 0. rake persvr:stop RAILS_ENV=test; reset
  # 1. rake yogo:spec; reset
  # 2. rake persvr:start RAILS_ENV=test; reset
  # 3. rake spec # => success!
  # 4. rake spec # => FAIL! # => SO MYSTERIOUS!
  # n... rake spec # => subsequent successes (?!)
  it "should not overwrite a model that already exists" do
    file_name = "#{SPEC_ROOT}/models/csv/csvtest.csv"
    p = Project.create(:name => "Overwrite") 
    p.process_csv(file_name, 'Csvtest')
    results = p.search_models('csvtest')
    results.should be_an Array
    results.length.should eql(1)
    results[0].name.should eql("Yogo::Overwrite::Csvtest")
    
    Yogo::Overwrite::Csvtest.should_not be_nil
    results[0].count.should eql(3)
    
    errors = p.process_csv(file_name, 'Csvtest')
    errors.should be_empty
    results2 = p.search_models('csvtest')
    results2.should be_an Array
    results2.length.should eql(1)
    results2[0].name.should eql("Yogo::Overwrite::Csvtest")
    results2[0].count.should eql(6)
    
    p.delete_models!
    p.destroy
  end
  
  it  "should get the right model with get_model" do
    models = ["a_giraffe", 'gazelles', 'giraffes']
    p = Project.create(:name => 'Zoo')
    models.each do |m|
      p.add_model(m, {:name => {:type => String}})
    end
    p.get_model('giraffe').name.should == 'Yogo::Zoo::Giraffe'
    p.get_model('aGiraffe').name.should == 'Yogo::Zoo::AGiraffe'
  end
  
  describe "contains references to reflected datamapper models" do
    it "should contain an array of reflected models" do
      p = Project.create(:name => "Build Project")
      p.should respond_to(:models)
      p.models.should_not be_nil
      p.models.should be_instance_of(Array)
      p.models.each do |m|
        m.should be_instance_of(DataMapper::Property)
      end
    end
  
    it "should respond to an add_model method that creates a model" do
      project = Project.create(:name => "Test Project 1")
      property_hash = {
        "name" => {:type => String},
        "id"   => {:type => DataMapper::Types::Serial}
      }
      m = project.add_model("Cell", property_hash)
      m.should == Yogo::TestProject1::Cell
      Yogo::TestProject1::Cell.ancestors.should include(DataMapper::Resource)
    end
  
    it "should make the newly added model available via .models" do
      project = Project.create(:name => "Test Project 8")
      property_hash = {
        "name" => {:type => String},
        "id"   => {:type => Integer}
      }
      project.add_model("Cell",property_hash)
      model_names = project.models.map(&:name)
      model_names.map{|m| m.match(/^Yogo::#{project.namespace}::Cell/)}.compact.should_not be_empty
    end
  
  
    it "should properly namespace an un-namespaced model hash" do
      project = Project.create(:name => "Test Project 2")
      property_hash = {
        "name" => {:type => String},
        "id"   => {:type => DataMapper::Types::Serial}
      }
      
      project.add_model("Monkey",property_hash)
      model_names = project.models.map(&:name)
      model_names.map{|m| m.match(/^Yogo::#{project.namespace}::Monkey/)}.compact.should_not be_empty
    end
  
    it "should save a valid schema which should be persisted to the datastore" do
      # This is already in the test database and should be pre-populated for 
      # the above project
      persisted_model_hash = { 
        "id" => "yogo__persisted_datum__cell",
        "properties" => {
          "name" => {"type" => "string"}
        }
      }
      # Simulate a situation where a schema exists prior to the app starting
      repository.adapter.put_schema(persisted_model_hash)
      # Create a project associated with the pre-existing data
      project = Project.create(:name => 'Persisted Data')
      DataMapper::Reflection.reflect(:default)
      # The models in the datastore should be reflected and exist
      project.models.map(&:name).should == ["Yogo::PersistedDatum::Cell"]
      Yogo::PersistedDatum::Cell.should_not be_nil
      
      #clean up
      project.destroy # => destroys the PersistedDatum project object
    end
    
  
    it "should be able to delete its schemas" do
      persisted_model_hash = { 
        "id" => "yogo__persisted_bozons__cell",
        "properties" => {
          "name" => {"type" => "string"}
        }
      }
      repository.adapter.put_schema(persisted_model_hash)
      project = Project.new(:name => 'Persisted Bozon')
      DataMapper::Reflection.reflect(:default)
      project.models.should_not be_empty
      project.delete_models!
      project.models.should be_empty
      project.destroy
      # => TODO: Should this be true?, because it currently isn't.
      # Yogo::PersistedBozon::Cell.should be_nil
      # Yogo::PersistedBozon.should be_nil
    end
  end 
  
  def project_builder(opts = {})
    u = standard_user
    u.save
    p = Project.create({:name => 'Test Project'}.merge(opts))
    group = p.groups.first(:name => 'owner')
    group.users << u
    group.save
    debugger
  end
  
  
end