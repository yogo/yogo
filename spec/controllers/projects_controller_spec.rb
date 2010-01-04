require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProjectsController do

  def mock_project(stubs={})
    @mock_project ||= mock_model(Project, stubs)
  end

  describe "GET projects/" do
    it "should retrieve all projects" do
      Project.should_receive(:all).and_return([mock_project])
      get :index
      assigns[:projects].should == [mock_project]
    end
  end
end