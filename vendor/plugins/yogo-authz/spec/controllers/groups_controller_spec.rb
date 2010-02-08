require File.join(File.dirname(__FILE__), "../spec_helpers")

module GroupsControllerSpec
  describe Yogo::GroupsController, "Post create" do
  
    before(:each) do
      @group = mock_model(Yogo::Group, :save => nil)
      Yogo::Group.stub!(:new).and_return(@group)
    end
  
    it "should create a new group" do
      Yogo::Group.should_receive(:new).
        with("name" => "test", "parent_id" => '').
        and_return(@group)
      post :create, :group => {"name" => "test", "parent_id" => ''}
    end
  
    it "should save the group" do
      @group.should_receive(:save).and_return(true)
      post :create, :group => {"name" => "test", "parent_id" => ''}
    end
    
    context "when the group save successfully" do
      before(:each) do
        @group.stub!(:save).and_return true
      end
      
      it "should set a flash[:notice] message" do
        post :create, :group => {"name" => "test", "parent_id" => ''}
        flash[:notice].should == "Group was successfully created."
      end
      
      it "should redirect somewhere" do
        post :create, :group => {"name" => "test", "parent_id" => ''}
        response.should redirect_to(group_url(@group.id))
      end
    end
  end
  
end
