require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe "A Project" do
  it "should not be created without a name" do
    lambda do
      p = Project.new
      p.should_not be_valid   
      p.save
    end.should_not change(Project.all,:count)
  end

  it "should be created with a name" do
    lambda do
      p = Project.create(:name => "Test Project")
    end.should change(Project.all,:count).by(1)
  end
end