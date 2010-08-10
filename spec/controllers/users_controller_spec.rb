require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UserSessionsController do

  def mock_warden
    request.env["warden"] = mock('Warden')
    request.env["warden"].stub!(:user)
  end

  before :each do
    mock_warden
  end
  
  after(:all) do
    User.all.destroy
  end
  
  describe "when not logged in" do
    before :each do
      request.env["warden"].stub!(:user).and_return(nil)
      request.env["warden"].stub!(:authenticated?).and_return(false)
    end
    
    it "should allow access to the login page through show" do
      get :show
      response.should be_redirect
      response.should redirect_to(login_url)
    end
    
    it "should allow access to the login page through new" do
      get :new
      response.should be_success
    end
    
    # it "should allow access to the login page through unauthenticated" do
    #   get :unauthenticated
    #   response.should be_success
    # end

    it "should not allow access to the logout page" do
      delete :destroy
      response.should be_redirect
      response.should redirect_to(login_url) #bah?
    end
    
    it "should login a user" do
      request.env["warden"].stub!(:authenticate!).and_return(true)
      
      standard_user(:login => 'user', :password => 'a_pass', :password_confirmation => 'a_pass').save
      
      post(:create, :login => 'user', :password => 'a_pass')
      response.should redirect_to('/')
    end
  end
  
  describe "when logged in" do
    before :each do
      User.all.destroy
      u = standard_user
      u.save
      request.env["warden"].stub!(:user).and_return(u)
      request.env["warden"].stub!(:authenticated?).and_return(true)
      request.env["warden"].stub!(:raw_session).and_return({}) # This is bad, but trust me
      request.env["warden"].stub!(:logout).and_return(true)
    end
    
    it "should redirect to the new page" do
      get :show
      response.should be_redirect
      response.should redirect_to(login_url)
    end
    
    it "should now allow access to the create action" do
      post(:create, :login => 'user', :password => 'a_pass')
      response.should be_redirect
      response.should redirect_to('/')
    end
    
    it "should not allow access to the login page and redirect to root" do
      get :new
      response.should be_redirect
      response.should redirect_to('/')
    end
    
    it "should allow access to the logout page" do
      delete :destroy
      response.should be_redirect
      response.should redirect_to('/')
    end
  end
end
