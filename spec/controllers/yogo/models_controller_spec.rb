require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Yogo::ModelsController do
  
  def mock_project(stubs={})
    @mock_project ||= begin 
                        @mock_project = mock_model(Project, stubs)
                        @mock_project.stub!(:get_model).with('Vanilla').and_return(mock_yogo_model)
                        @mock_project.stub!(:models).and_return([mock_yogo_model])
                        @mock_project.stub!(:delete_model).and_return(true)
                        @mock_project.stub!(:add_model).and_return(mock_yogo_model)
                        @mock_project
                      end
  end

  def mock_yogo_model
    @mock_model ||= mock('YogoModel', 
                    :to_model_definition => '{key: value}', 
                    :update_model_definition => true, 
                    :properties => [],
                    :guid => 'Bacon',
                    :name => 'Bacon',
                    :auto_migrate! => true)
  end

  
  def mock_warden
    request.env["warden"] = mock('Warden')
    request.env["warden"].stub!(:user)
  end

  before :each do
    mock_warden
  end

  describe "when running locally" do
    before(:all) do
      Yogo::Setting[:local_only] = true
    end
    
    it "should be local only" do
      Yogo::Setting[:local_only].should be_true
    end
    
    describe 'POST' do
    end # POST tests
  
    describe 'GET' do
      it "should GET " do
        Project.stub!(:get).with("42").and_return(mock_project)
        get :index, :project_id => '42'
        
        response.should be_success
        response.should render_template('index')
      end
    end # GET tests
  
    describe 'PUT' do
    end # PUT tests
  
    describe 'DELETE' do
    end # DELETE tests
  end # when running locally

  describe "when running as a server" do
    before(:all) do
      Yogo::Setting[:local_only] = false
    end
    
    it "should be local only" do
      Yogo::Setting[:local_only].should be_false
    end
    
    describe "when not logged in" do
      before(:each) do
        request.env["warden"].stub!(:authenticated?).and_return(false)
      end
      
      describe 'GET' do
        it "should GET index with a public project" do
          Project.stub!(:get).with("42").and_return(mock_project(:is_public? => true))
          
          get :index, :project_id => '42'

          response.should be_success
          response.should render_template('index')
        end
        
        it "should GET show with a public project" do
          Project.stub!(:get).with("42").and_return(mock_project(:is_public? => true))
          get :show, :project_id => '42', :id => 'Vanilla'

          response.should be_success
          response.should render_template('show')
        end
        
        it "should not GET index with a private project" do
          Project.stub!(:get).with("42").and_return(mock_project(:is_public? => false))
          get :index, :project_id => '42'

          response.should be_redirect
          response.should redirect_to(login_url)
        end
        
        it "should not GET show with a private project" do
          Project.stub!(:get).with("42").and_return(mock_project(:is_public? => false))
          get :show, :project_id => '42', :id => 'Vanilla'

          response.should be_redirect
          response.should redirect_to(login_url)
        end
      end # GET tests

      describe 'POST' do
        it "should not work" do
          Project.stub!(:get).with("42").and_return(mock_project(:is_public? => true))
          post :create, :project_id => '42', 'Model' => 'blah'

          response.should be_redirect
          response.should redirect_to(login_url)
        end
      end # POST tests

      describe 'PUT' do
        it "should not work" do
          Project.stub!(:get).with("42").and_return(mock_project(:is_public? => true))
          put :update, :project_id => '42', :id => 'Vanilla', 'Model' => 'blah'

          response.should be_redirect
          response.should redirect_to(login_url)
        end
      end # PUT tests

      describe 'DELETE' do
        it "should not work" do
          Project.stub!(:get).with("42").and_return(mock_project(:is_public? => true))
          delete :destroy, :project_id => '42', :id => 'Vanilla'

          response.should be_redirect
          response.should redirect_to(login_url)
        end
      end # DELETE tests

    end # when not logged in
    
    describe "when logged in" do
      before(:each) do
        User.all.destroy
        @u = standard_user
        @u.save
        request.env["warden"].stub!(:user).and_return(@u)
        request.env["warden"].stub!(:authenticated?).and_return(true)
      end
      
      describe "without permissions" do
        before(:each) do
          @u.stub!(:has_permission?).and_return(false)
          Project.stub!(:get).with("42").and_return(mock_project(:is_public? => false))
        end
        it "should not GET index" do
          get(:index, :project_id => '42')
          response.should be_redirect
        end
        it "should not GET show" do
          get(:show, :project_id => '42', :id => 'Vanilla')
          response.should be_redirect
        end
        it "should not GET new" do
          get(:new, :project_id => '42')
          response.should be_redirect
        end
        it "should not GET edit" do
          get(:edit, :project_id => '42', :id => 'Vanilla')
          response.should be_redirect
        end
        it "should not POST" do
          post(:create, :project_id => '42')
          response.should be_redirect
        end
        it "should not PUT" do
          put(:update, :project_id => '42', :id => 'Vanilla')
        end
        it "should not DELETE" do
          delete(:destroy, :project_id => '42', :id => 'Vanilla')
        end
      end # without permissions

      describe "with permissions" do
        before(:each) do
          @u.stub!(:has_permission?).and_return(true)
          Project.stub!(:get).with("42").and_return(mock_project(:is_public? => false))
        end
        it "should GET index" do
          get(:index, :project_id => '42')
          response.should be_redirect
        end
        it "should GET show" do
          get(:show, :project_id => '42', :id => 'Vanilla')
          response.should be_redirect
        end
        it "should GET new" do
          get(:new, :project_id => '42')
          response.should_not be_redirect
          response.should render_template('new')
        end
        it "should GET edit" do
          get(:edit, :project_id => '42', :id => 'Vanilla')
          response.should_not be_redirect
          response.should render_template('edit')
        end
        it "should POST" do
          post(:create, :project_id => '42', :Model => {:guid => 'Bacon'})
          response.should be_redirect
          # response.should redirect_to(project_yogo_data_path(mock_project, mock_yogo_model))
        end
        it "should PUT" do
          put(:update, :project_id => '42', :id => 'Vanilla')
        end
        it "should DELETE" do
          delete(:destroy, :project_id => '42', :id => 'Vanilla')
        end
      end # with permissions
    end # when logged in
  end # when running as a server

end # YogoModelsController 