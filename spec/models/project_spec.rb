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
end