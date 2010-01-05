require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe "A Project" do
  
  it "should not be created without a name" do
    count = Project.all.count
    p = Project.new
    p.should_not be_valid   
    p.save
    count.should == Project.all.count
  end

  it "should be created with a name" do
    count = Project.all.count
    p = Project.create(:name => "Test Project")
    count.should == Project.all.count - 1
  end
  
  it "should respond to to_param with the id as a string" do
    p = Project.create(:name => "Test Project")
    p.to_param.should == p.id.to_s
  end
  
  it "should respond to new_record? with its new? value" do
    p = Project.new
    p.should be_new
    p.should be_new_record
    p.name = 'Test Project'
    p.save
    p.should_not be_new
    p.should_not be_new_record
  end
  
  # This is a joke and could be removed
  it "should implement a useful method" do
    Project.new.should respond_to(:puts_moo)
  end
  
  describe "uses a yogo Data Store" do
    
    it "should have a yogo_collection of data" do
      p = Project.create(:name => "Test Project")
      p.yogo_collection.should_not be_nil
    end

  end
end