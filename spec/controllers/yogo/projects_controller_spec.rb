require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Yogo::ProjectsController do

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
  end

  describe "when running locally" do
    
    before(:all) do
      Yogo::Setting[:local_only] = true
    end
    
    describe "GET projects/" do
    
      # this doesn't happen any more.
      # it "assigns all projects as @projects" do
      #      projects = [mock_project]
      #      Project.should_receive(:all).and_return(projects)
      #      get :index
      #      assigns[:projects].should equal(projects)
      #    end
  
    end

    describe "GET projects/:id" do
      it "assigns the requested project as @project" do
        Project.stub!(:get).with("37").and_return(mock_project(:models => [], :is_public? => true))
        get :show, :id => "37"
        assigns[:project].should equal(mock_project)
        response.should be_success
        response.should_not be_redirect
      end
    end

    describe "GET projects/new"   do
    
      it "redirects to the project_wizard" do
        get :new
        response.should redirect_to(start_wizard_url)
      end
    
    end

    describe "GET projects/edit" do
      it "assigns the requested project as @project" do
        Project.stub!(:get).with("37").and_return(mock_project)
        get :edit, :id => "37"
        assigns[:project].should equal(mock_project)
      end
    end
  
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
          post :create, :yogo => { :name => 'Test Project' }
        
          response.should redirect_to(csv_question_url(mock_project))
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
  
    describe "PUT projects/:id" do
    
      describe "with valid params" do
        it "updates the requested project, flashes a notice" do
          Project.should_receive(:get).with("37").and_return(
            mock_project(:attributes= => true, :save => true, :name => 'Test Project', :name => 'proj')
          )
          mock_project.should_receive(:attributes=)
          put :update, :id => "37", :project => {:name => 'Test Project'}
          response.flash[:notice].should =~ /has been updated/i      
        end
    
        it "assigns the requested project as @project" do
          Project.stub!(:get).and_return(
            mock_project(:attributes= => true, :save => true, :name => 'Test Project', :name => 'proj')
          )
          put :update, :id => "1", :project => {:name => 'Test Project'}
          assigns[:project].should equal(mock_project)
        end
            
        it "redirects to the project list" do
          Project.stub!(:get).and_return(
            mock_project(:attributes= => true, :save => true, :name => 'Test Project', :name => 'proj')
          )
          put :update, :id => "1", :project => {:name => 'Test Project'}
          response.should redirect_to(projects_url)
        end
      end
    
      describe "with invalid params" do
        it "does not update the requested project, flashes an error" do
          Project.should_receive(:get).with("37").and_return(mock_project(:save => false))
          mock_project.should_receive(:attributes=).with({"these" => 'params'})
          put :update, :id => "37", :project => {:name => 'Test Project', :these => 'params'}
          response.flash[:error].should =~ /could not be updated/i      
        end
        
        it "assigns the project as @project" do
          Project.stub!(:get).and_return(
            mock_project(:attributes= => false, :save => false, :name => 'Test Project')
          )
          put :update, :id => "1", :project => {:name => 'Test Project'}
          assigns[:project].should equal(mock_project)
        end
        
        it "re-renders the 'edit' template" do
          Project.stub!(:get).and_return(
            mock_project(:attributes= => false, :save => false, :name => 'Test Project')
          )
          put :update, :id => "1", :project => {:name => 'Test Project'}
          response.should render_template('edit')
        end
      end
    
    end

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
  end


  describe "when running in server mode" do
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

      describe "GET project/:id" do
        it "should not be able to view a private project" do
          Project.stub!(:get).with("37").and_return(mock_project(:models => [], :is_public? => false))
          
          get :show, :id => "37"
          assigns[:project].should equal(mock_project)
          response.should be_redirect
        end
        
        it "should be able to to view a public project" do
          Project.stub!(:get).with("37").and_return(mock_project(:models => [], :is_public? => true))
          
          get :show, :id => "37"
          assigns[:project].should equal(mock_project)
          response.should be_success
          response.should_not be_redirect
        end
      end

      describe "GET project/:id/edit" do
        it "should not be able to edit a project" do
          Project.stub!(:get).with("37").and_return(mock_project(:models => []))
          get :edit, :id => "37"
          response.should be_redirect
          response.should redirect_to(new_user_session_url)
        end
                                               
      end

      describe "PUT project/:id" do
        it "should not be able to update a project" do
          put :update, :id => "37"
          response.should redirect_to(new_user_session_url)
        end
      end
      
      describe "DELETE project/:id" do
        it "should not be able to delete a project" do
          Project.stub!(:get).with("37").and_return(mock_project(:models => []))
          delete :destroy, :id => "37"
          
          response.should be_redirect
          response.should redirect_to(new_user_session_url)
        end
      end
      
    end
    
    describe "when logged in" do
      before(:each) do
        @u = standard_user
        @u.save
        request.env["warden"].stub!(:user).and_return(@u)
        request.env["warden"].stub!(:authenticated?).and_return(true)
      end

      describe "GET /project/:id" do
        it "should not allow a user without a project group to view a private project" do
          Project.stub!(:get).with("37").and_return(mock_project(:models => [], :is_public? => false))
          @u.stub!(:is_in_project?).and_return(false)
          
          get :show, :id => "37"
          
          response.should be_redirect
        end
        
        it "should allow a user in a project group to view a private project" do
          @u.stub!(:is_in_project?).and_return(true)
          Project.stub!(:get).with("37").and_return(mock_project(:models => [], :is_public? => false))
          
          get :show, :id => "37"
          response.should be_success
          response.should_not be_redirect
        end
      end

      describe "GET /project/:id/edit" do
        it "should not allow a user without group priviliges to edit a project" do
          Project.stub!(:get).with("37").and_return(mock_project(:models => [], :is_public? => false))
          @u.stub!(:has_permission?).with(:edit_project, mock_project).and_return(false)
          
          get :edit, :id => "37"
          
          # The exception should be caught and handled in ApplicationController
          response.should be_redirect
        end
        
        it "should allow a user with group priviliges to edit a project" do
          Project.stub!(:get).with("37").and_return(mock_project(:models => [], :is_public? => false))
          @u.stub!(:has_permission?).with(:edit_project, mock_project).and_return(true)
          
          get :edit, :id => "37"
          
          response.should be_success
        end
      end

      describe "PUT /project/:id" do
        it "should not allow a user without group priviliges to update a project" do
          Project.stub!(:get).with("37").and_return(mock_project(:models => [], :is_public? => false))
          @u.stub!(:has_permission?).with(:edit_project, mock_project).and_return(false)
          
          put :update, :id => "37"
          
          # The exception should be caught and handled in ApplicationController
          response.should be_redirect
        end
        
        it "should allow a user with group priviliges to update a project" do
          Project.stub!(:get).with("37").and_return(mock_project(:models => [], :is_public? => false, :save => true, :name => 'proj'))
          @u.stub!(:has_permission?).with(:edit_project, mock_project).and_return(true)
          mock_project.should_receive(:attributes=).with({'these' => 'params'})
          
          put :update, :id => "37", :project => {:name => 'blah', 'these' => 'params'}
          
          response.should be_redirect
        end
      end

      describe "delete /project/:id" do
        it "should not allow a user without group priviliges to delete a project" do
          Project.stub!(:get).with("37").and_return(mock_project(:models => [], :destroy => false))
          @u.stub!(:has_permission?).with(:edit_project, mock_project).and_return(false)
          delete :destroy, :id => "37"
          
          response.should be_redirect
        end
        
        it "should allow a user without group priviliges to delete a project" do
          Project.stub!(:get).with("37").and_return(mock_project(:models => [], :destroy => true, :name => 'a dead project'))
          @u.stub!(:has_permission?).with(:edit_project, mock_project).and_return(true)
          delete :destroy, :id => "37"
          
          response.should be_redirect
          response.should redirect_to(projects_url)
        end
      end
    end # when logged in
  end # when running in server mode
  
end # projects controller
