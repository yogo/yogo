require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Group do

  before(:all) do
    User.current = nil
  end
  
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
    Group.count.should eql 0
    Project.count.should eql 0
    User.count.should eql 0
    p = Project.create(:name => 'test_project') # This should create 5 groups
    
    g = standard_group(:name => 'test') # This creates 1 group
    g.save

    Group.count.should eql(Group::PROJECT_ACTIONS.length + 2)
    Group.count(:project => p).should eql 6
    
    Group.all(:project => nil).length.should eql 1
  end
  
  it "should contain permissions do perform certain actions" do
    g = standard_group(:name => 'test')
    
    g.should respond_to(:permissions)
  end
  
  it "should start of with no permissions" do
    g = standard_group
    g.save
    
    g.permissions.should be_empty
  end
  
  it "should be able to have new permissions added to it" do
    g = standard_group
    
    g.add_permission(:edit_project)
    
    g.have_permission?(:edit_project).should be_true
  end
  
  it "should not be able to add permissions that don't exist" do
    g = standard_group
    
    lambda {
      g.add_permission('dummy_permission')
    }.should raise_exception(NonExistantPermissionError, "dummy_permission is not a valid permission")

    lambda{ 
      g.have_permission?('dummy_permission')
    }.should raise_exception(NonExistantPermissionError, "dummy_permission is not a valid permission")
    
  end
  
  it "should be able to have permissions removed from it" do
    g = standard_group
    
    g.add_permission( :create_projects )
    g.add_permission( :edit_project )
    
    g.have_permission?(:create_projects).should be_true
    g.remove_permission(:create_projects)

    g.have_permission?(:create_projects).should_not be_true
  end
  
  it "should save and load permissions from a database" do
    g = standard_group
    
    g.add_permission( :create_projects )
    g.add_permission( :edit_project )
    
    g.save

    g = Group.first
    
    g.have_permission?(:create_projects).should be_true
    g.have_permission?(:edit_project).should be_true
    
  end
  
  it "should be able to store every permission and recall them" do
    g = standard_group
    g.save
    
    [:edit_project, :edit_model_descriptions, :edit_model_data, :delete_model_data].each do |action|
      g.add_permission(action)
    end

    g.permissions.split(' ').length.should eql 4
    
    g.save
    
    g = Group.first
    g.permissions.split(' ').length.should eql 4
    g.have_permission?(:edit_project).should be_true
  end
end
