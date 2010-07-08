require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Yogo::UsersController do

  def mock_project(stubs={})
    @mock_project ||= mock_model(Project, stubs)
  end
  
  def mock_groups(stubs={})
    @mock_groups ||= begin
      mg = [ mock_model(Group, stubs),
             mock_model(Group, stubs)
           ]
      mg.stub(:users).and_return([])
      mg
    end
  end
  
  # def mock_models(proj)
  #   [ build_reflected_model('Vanilla',    proj),
  #     build_reflected_model('Chocolate',  proj),
  #     build_reflected_model('Strawberry', proj)
  #     ]
  # end

  def mock_warden
    request.env["warden"] = mock('Warden')
    request.env["warden"].stub!(:user)
  end

  before :each do
    mock_warden
    Project.should_receive(:get).with("42").and_return(mock_project)
    mock_project.should_receive(:groups).and_return(mock_groups)
  end
  
  describe "when local only in" do
    before(:all) do
      Yogo::Setting[:local_only] = true
    end
    
    describe "GET /" do
      it "should description" do
        get(:index, :project_id => "42")
        assigns[:users].should_not be_nil
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
      describe "GET /new" do
        it "should not be able to view a user" do
          get(:new, :project_id => "42")
          response.should_not be_success
          response.should be_redirect
        end
      end # when not logged in
    end
    
    describe "when logged in with permission" do
      before(:each) do
        User.all.destroy
        @u = standard_user
        @u.save
        request.env["warden"].stub!(:user).and_return(@u)
        request.env["warden"].stub!(:authenticated?).and_return(true)
        request.env["warden"].stub!(:raw_session).and_return({}) # This is bad, but trust me
        @u.should_receive(:has_permission?).with(:edit_project, mock_project).and_return(true)
      end
      
      describe("GET /") do
        it "should should respond with a list of users" do
          get(:index, :project_id => "42")
          response.should be_success
          response.should render_template("index")
        end
      end
      describe("GET /new") do 
        it "should be able to get the new user page" do
          get(:new, :project_id => "42")
          response.should be_success
          assigns[:user].should_not be_nil
        end
      end
      describe("POST") do
        it "should create a valid new user" do
          post(:create, :project_id => '42', 
               :user => {:login => 'test user', 
                         :password => 'test_password',
                         :password_confirmation => 'test_password'})
          assigns[:user].should_not be_nil
          response.should redirect_to(project_users_url(mock_project))
        end
        it "should re-render the new user page when invalid user info is given" do
          post(:create, :project_id => '42',
               :user => {:login => 'blah'})
          assigns[:user].errors.should_not be_empty
          response.should be_success
          response.should render_template('new')
        end
      end
    end
  end

end