require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PasswordsController do

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
    
    [:show, :edit ].each do |action|
      it "should not allow access to #{action}" do
        get action
        response.should be_redirect
        response.should redirect_to(login_url)
      end
    end
    
    it "should not allow access to update" do
      put :update
      response.should be_redirect
      response.should redirect_to(login_url)
    end
  end
  
  describe "when logged in" do
    before :each do
      User.all.destroy
      @u = standard_user
      @u.save
      request.env["warden"].stub!(:user).and_return(@u)
      request.env["warden"].stub!(:authenticated?).and_return(true)
      request.env["warden"].stub!(:raw_session).and_return({}) # This is bad, but trust me
      request.env["warden"].stub!(:logout).and_return(true)
    end
    
    it "should allow access through the show action" do
      get :show
      response.should be_redirect
      response.should redirect_to(:action => 'edit')
    end
    
    it "should allow access through the edit action" do
      get :edit
      response.should be_success
      assigns[:user].should equal(@u)
    end
    
    it "should update the password when valid passwords are given" do
      put(:update, :user => {:password => 'new_pass', :password_confirmation => 'new_pass'})
      
      response.should redirect_to("/")
      assigns[:user].should equal(@u)
      (assigns[:user].crypted_password == "new_pass").should be_true
    end
    
    it "should render the edit page when there are bad passwords given" do
      put(:update, :user => {:password => 'new_pass', :password_confirmation => 'bonk'})
      
      assigns[:user].should equal(@u)
      response.should render_template("edit")
    end
  end
  
end