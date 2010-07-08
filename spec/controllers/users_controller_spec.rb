require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do
  
  def mock_warden
    request.env["warden"] = mock('Warden')
    request.env["warden"].stub!(:user)
  end

  before(:all) do
    standard_group(:admin => 'true', :name => 'administrators').save
  end
  
  after(:all) do
    User.all.destroy
    Group.all.destroy
  end

  before(:each) do
    mock_warden
  end
  
  describe "when working with administrators" do
    before :each do
      mock_warden
      User.all.destroy
      @admin_group = Group.first(:admin => true)
      @u = standard_user
      @u.groups << @admin_group
      @u.save
      request.env["warden"].stub!(:user).and_return(@u)
      request.env["warden"].stub!(:authenticated?).and_return(true)
      request.env["warden"].stub!(:raw_session).and_return({}) # This is bad, but trust me
      request.env["warden"].stub!(:logout).and_return(true)
    end

    it "should allow users that belong to an admin group" do
      get :index
      response.should be_success
      response.should_not be_redirect
      assigns[:users].should_not be_nil
    end

    it "should be able to view a single user" do
      mock_user = mock_model(User)
      # Project.stub!(:get).with("37").and_return(mock_project(:models => []))
      User.stub!(:get).with("37").and_return(mock_user)
      get :show, :id => "37"
      response.should be_success
      assigns[:user].should equal(mock_user)
    end

    it "should be able to edit a single user" do
      mock_user = mock_model(User)
      User.stub!(:get).with("42").and_return(mock_user)
      get :edit, :id => "42"
      response.should be_success
      assigns[:user].should equal(mock_user)
    end

    it "should be able to get the new user page" do
      get :new
      response.should be_success
      assigns[:user].should_not be_nil
    end

    it "should be able to post a new user" do
      post(:create, :user => {:login => 'test',
             :password => 'a big password',
             :password_confirmation => 'a big password'})
      
      assigns[:user].should_not be_nil
      flash[:notice].should eql("User created")
      response.should redirect_to(users_url)
    end

    it "should re-render the new user page when invalid user info is given" do
      post(:create,
           :user => {:login => 'blah'})
      assigns[:user].errors.should_not be_empty
      response.should be_success
      response.should render_template('new')
    end

    it "should be able to update a user" do
      mock_user = mock_model(User)
      User.stub!(:get).with("42").and_return(mock_user)
      mock_user.stub!(:attributes=)
      mock_user.stub!(:valid?).and_return(true)
      mock_user.stub!(:save)
      mock_user.stub!(:to_param).and_return('42')
      
      put(:update, :id => '42',  :user => {:id => '42', :login => 'blah' })

      response.should redirect_to(user_url(:id => '42'))
    end
    
    it "should not update a user with invalid data" do
      mock_user = mock_model(User)
      User.stub!(:get).with("42").and_return(mock_user)
      mock_user.stub!(:attributes=)
      mock_user.stub!(:valid?).and_return(false)

      mock_user.stub!(:to_param).and_return('42')
      
      put(:update, :id => '42',  :user => {:id => '42', :login => 'blah' })

      assigns[:user].should eql mock_user
      response.should render_template('edit')
    end
    
    it "should not update a password" do
      u = standard_user
      u.save
      User.stub!(:get).with("42").and_return(u)
      u.should_not_receive(:password=)
      u.should_not_receive(:password_confirmation=)
      u.stub!(:to_param).and_return('42')
      
      put(:update, :id => '42',  :user => {:id => '42', :login => 'blah', :password => 'blah', :password_confirmation => 'blah' })
      
      response.should(redirect_to(user_url(:id => 42)))
    end

    it "should be able to destroy a user" do
      mock_user = mock_model(User)
      User.stub!(:get).with("20").and_return(mock_user)
      mock_user.stub!(:destroy)

      delete(:destroy, :id => '20')
      response.should redirect_to(users_url)
    end
  end

  describe "when working with non-administrators" do
    before :each do
      mock_warden
      User.all.destroy
      @u = standard_user
      @u.save
      request.env["warden"].stub!(:user).and_return(@u)
      request.env["warden"].stub!(:authenticated?).and_return(true)
      request.env["warden"].stub!(:raw_session).and_return({}) # This is bad, but trust me
      request.env["warden"].stub!(:logout).and_return(true)
    end

    it "should redirect when viewing the index index" do
      get :index
      response.should be_redirect
    end

    it "should redirect when getting a specific user" do
      get :show, :id => 1
      response.should be_redirect
    end

    it "should redirect when requesting the new form" do
      get :new
      response.should be_redirect
    end

    it "should do something when a post is made" do
      post :create
      response.should be_redirect
    end

    it "should redirect when an update is made" do
      put :update, :id => 1
      response.should be_redirect
    end

    it "should redirect when a destroy is made" do
      delete :destroy, :id => 1
      response.should be_redirect
    end
    
  end
  
  
end
