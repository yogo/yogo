require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProjectsController do

  def mock_project(stubs={})
    @mock_project ||= mock_model(Project, stubs)
  end

  
  def mock_models(proj)
    [ build_reflected_model('Vanilla',    proj),
      build_reflected_model('Chocolate',  proj),
      build_reflected_model('Strawberry', proj)
      ]
  end

  describe "GET projects/" do
  
    it "assigns all projects as @projects" do
      projects = [mock_project]
      Project.should_receive(:all).and_return(projects)
      get :index
      assigns[:projects].should equal(projects)
    end
  
  end

  #There is no projects#show action at this time.
  describe "GET projects/:id" do
    it "assigns the requested project as @project" do
      Project.stub!(:get).with("37").and_return(mock_project(:models => []))
      get :show, :id => "37"
      assigns[:project].should equal(mock_project)
    end
  end

  describe "GET projects/new"   do
    it "assigns a new project as @project" do
      Project.stub!(:new).and_return(mock_project)
      get :new
      assigns[:project].should equal(mock_project)
    end
  end

  # describe "GET projects/edit" do
  #   it "assigns the requested project as @project" do
  #     Project.stub!(:get).with("37").and_return(mock_project)
  #     get :edit, :id => "37"
  #     get edit_project_path(:id => "37")
  #     assigns[:project].should equal(mock_project)
  #   end
  # end
  
  describe "POST projects" do

    describe "with valid params" do
      it "assigns a newly created project as @project, flashes a notice" do
        Project.should_receive(:new).with('name'=> 'Test Project').and_return(
          mock_project(:save => true, :name => 'Test Project', :id => 1)
        )
        post :create, :project => {:name => 'Test Project'}
        assigns[:project].should equal(mock_project)
        response.flash[:notice].should =~ /has been created/i      
      end

      it "redirects to the project list" do
        Project.stub!(:new).and_return(
          mock_project(:save => true, :name => 'Test Project')
        )
        post :create, :yogo => {}
        response.should redirect_to(projects_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved project as @project" do
        Project.stub!(:new).with({'name' => 'Test Project'}).and_return(
          mock_project(:save => true, :name => 'Test Project')
        )
        post :create, :project => {:name => 'Test Project'}
        assigns[:project].should equal(mock_project)
      end

      it "re-renders the 'new' template, flashes an error" do
        Project.stub!(:new).and_return(mock_project(:save => false))
        post :create, :project => {}
        response.should render_template('new')
        response.flash[:error].should =~ /could not be created/i      
      end
    end

  end
  
  # describe "PUT projects/:id" do
  # 
  #   describe "with valid params" do
  #     it "updates the requested project, flashes a notice" do
  #       Project.should_receive(:get).with("37").and_return(
  #         mock_project(:attributes= => true, :save => true, :name => 'Test Project')
  #       )
  #       mock_project.should_receive(:attributes=).with({'name' => 'Test Project'})
  #       put :update, :id => "37", :project => {:name => 'Test Project'}
  #       response.flash[:notice].should =~ /has been updated/i      
  #     end
  # 
  #     it "assigns the requested project as @project" do
  #       Project.stub!(:get).and_return(
  #         mock_project(:attributes= => true, :save => true, :name => 'Test Project')
  #       )
  #       put :update, :id => "1"
  #       assigns[:project].should equal(mock_project)
  #     end
  # 
  #     it "redirects to the project list" do
  #       Project.stub!(:get).and_return(
  #         mock_project(:attributes= => true, :save => true, :name => 'Test Project')
  #       )
  #       put :update, :id => "1"
  #       response.should redirect_to(projects_url)
  #     end
  #   end
  # 
  #   describe "with invalid params" do
  #     it "does not update the requested project, flashes an error" do
  #       Project.should_receive(:get).with("37").and_return(mock_project(:save => false))
  #       mock_project.should_receive(:attributes=).with({'these' => 'params'})
  #       put :update, :id => "37", :project => {:these => 'params'}
  #       response.flash[:error].should =~ /could not be updated/i      
  #     end
  # 
  #     it "assigns the project as @project" do
  #       Project.stub!(:get).and_return(
  #         mock_project(:attributes= => false, :save => false, :name => 'Test Project')
  #       )
  #       put :update, :id => "1"
  #       assigns[:project].should equal(mock_project)
  #     end
  # 
  #     it "re-renders the 'edit' template" do
  #       Project.stub!(:get).and_return(
  #         mock_project(:attributes= => false, :save => false, :name => 'Test Project')
  #       )
  #       put :update, :id => "1"
  #       response.should render_template('edit')
  #     end
  #   end
  # 
  # end

  describe "DELETE destroy" do
    describe "success" do 
      it "destroys the requested project" do
        Project.should_receive(:get).with("37").and_return(mock_project(:name => 'Test Project'))
        mock_project.should_receive(:destroy)
        delete :destroy, :id => "37"
      end

      it "redirects to the project list" do
        Project.stub!(:get).and_return(mock_project(:destroy => true, :name => 'Test Project'))
        delete :destroy, :id => "1"
        response.should redirect_to(projects_url)
      end
    end # success
    describe "failure" do
      it "does not destroy the requested project, flashes an error" do
        Project.should_receive(:get).with("37").and_return(mock_project(:name => 'Test Project'))
        mock_project.should_receive(:destroy).and_return(false)
        delete :destroy, :id => "37"
        response.flash[:error].should =~ /could not be destroyed/i      
      end
      it "redirects to the project list" do
        Project.stub!(:get).and_return(mock_project(:destroy => false, :name => 'Test Project'))
        delete :destroy, :id => "1"
        response.should redirect_to(projects_url)
      end
    end # failure
  end # POST tests

  #
  # At the project level cvs upload means creating a model and instances from a spreadsheet
  # There are a set of tests that should be done on the model creation piece, but
  # the instance creation tests overlap significantly with the yogo_models_controller csv handling.
  # 
  describe 'csv file handling' do
    # Data validation
    it 'should validate types are valid in the spreadsheet'
    it 'should return an error when bad types are used in the spreadsheet'
    # Model tests
    it 'should create a new model (overwriting any existing one)'
    # Instance tests
    it 'should create instances of the new model from all valid rows of the spreadsheet'
    it 'should warn about invalid instance/row data but continue to create subsequent instances'
  end # csv handling
end # projects controller