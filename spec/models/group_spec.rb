require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Group do
  
  before(:each) do
    User.all.destroy
    Group.all.destroy
    Project.all.destroy
  end
  
  it "should persist to the database" do
    group = standard_group
    group.save
    
    group.should be_valid
    Group.count.should eql 1
  end
  
  it "should be able to not belong to a project" do
    p = Project.create(:name => 'test_project')
    
    g = standard_group(:name => 'test')
    g.save
    
    Group.count.should eql 3
    Group.count(:project => p).should eql 2
    
    Group.all(:project => nil).length.should eql 1
  end
  
end