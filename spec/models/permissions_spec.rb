require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe "User Permissions" do
  
  before(:all) do
    SystemRole.create(:name => 'User', :description => 'Default user in the system',
                               :permissions => ["yogo/project$retrieve"])

    sr = SystemRole.first_or_new(:name => 'Project Manager', :description => 'Able to create projects',
                                 :permissions => Yogo::Project.to_permissions)

    sr = SystemRole.first_or_new(:name => 'Administrator', :description => 'System role for Administrators',
                                 :permissions => User.to_permissions + Yogo::Project.to_permissions)
    # Create the system administrator user
    @user = User.create(:login => 'yogo', :first_name => "System",
                        :last_name => "Administrator", :system_role => sr,
                        :password => 'change me', :password_confirmation => 'change me')
  end
  
  after(:all) do
    SystemRole.destroy
    User.destroy
  end
  
  describe "when a user has user permissions" do
    it "should have some permissions" do
      User.permissions.should_not be_empty
    end
    
    it "should wrap permissions" do
      User.access_as(@user).count.should eql 1
    end
  end
end

