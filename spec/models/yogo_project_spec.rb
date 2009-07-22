require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe "A YogoProject" do
  it "should not be created without a name" do
    YogoProject.create.should_not be_new
  end

  it "should be created with a name" do
    YogoProject.new(:name => "Test Project").should be_new
  end

  it "should generate a prefix from the name" do
    @yogo_project = YogoProject.new(:name => "Rspec Test Project")
    @yogo_project.prefix.should == "Yogo_RspecTestProject"
  end
end
