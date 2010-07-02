require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Yogo::UsersController do

  def mock_project(stubs={})
    @mock_project ||= mock_model(Project, stubs)
  end
  
  def mock_models(proj)
    [ build_reflected_model('Vanilla',    proj),
      build_reflected_model('Chocolate',  proj),
      build_reflected_model('Strawberry', proj)
      ]
  end

  def mock_warden
    request.env["warden"] = mock('Warden')
    request.env["warden"].stub!(:user)
  end

  before :each do
    mock_warden
    Project.should_receive(:get).with("42").and_return(mock_project)
    mock_project.should_receive(:groups).and_return([])
  end
  
  describe "when local only in" do
    before(:all) do
      Yogo::Setting[:local_only] = true
    end
    
    describe "GET /" do
      it "should description" do
        get(:index, :project_id => "42")
        response.should be_success
      end
    end
  end
  
  describe "when not local only" do
    before(:all) do
      Yogo::Setting[:local_only] = false
    end
    
    describe "when not logged in" do
      before(:each) do
        request.env["warden"].stub!(:authenticated?).and_return(false)
      end
      describe "GET /" do
        it "should get it" do
          get(:index, :project_id => "42")
          response.should_not be_success
        end
      end
      describe "GET /:id" do
        it "should not be able to view a user" do
          get(:show, :project_id => "42", :id => '10')
          response.should_not be_success
        end
      end
    end
  end

end