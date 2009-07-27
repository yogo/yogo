require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe YogoProjectsController do

  def mock_yogo_project(stubs={})
    @mock_yogo_project ||= mock_model(YogoProject, stubs)
  end

  describe "GET index" do
    it "assigns all yogo_projectses as @yogo_projectses" do
      YogoProject.stub!(:all).and_return([mock_yogo_project])
      get :index
      assigns[:yogo_projects].should == [mock_yogo_project]
    end
  end

  describe "GET show" do
    it "assigns the requested yogo_project as @yogo_project" do
      YogoProject.stub!(:get).with("37").and_return(mock_yogo_project)
      get :show, :id => "37"
      assigns[:yogo_project].should equal(mock_yogo_project)
    end
  end

  describe "GET new" do
    it "assigns a new yogo_project as @yogo_project" do
      YogoProject.stub!(:new).and_return(mock_yogo_project)
      get :new
      assigns[:yogo_project].should equal(mock_yogo_project)
    end
  end

  describe "GET edit" do
    it "assigns the requested yogo_project as @yogo_project" do
      YogoProject.stub!(:get).with("37").and_return(mock_yogo_project)
      get :edit, :id => "37"
      assigns[:yogo_project].should equal(mock_yogo_project)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created yogo_project as @yogo_project" do
        YogoProject.stub!(:new).with({'these' => 'params'}).and_return(mock_yogo_project(:save => true))
        post :create, :yogo_project => {:these => 'params'}
        assigns[:yogo_project].should equal(mock_yogo_project)
      end

      it "redirects to the created yogo_project" do
        YogoProject.stub!(:new).and_return(mock_yogo_project(:save => true))
        post :create, :yogo_project => {}
        response.should redirect_to(yogo_project_url(mock_yogo_project))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved yogo_project as @yogo_project" do
        YogoProject.stub!(:new).with({'these' => 'params'}).and_return(mock_yogo_project(:save => false))
        post :create, :yogo_project => {:these => 'params'}
        assigns[:yogo_project].should equal(mock_yogo_project)
      end

      it "re-renders the 'new' template" do
        YogoProject.stub!(:new).and_return(mock_yogo_project(:save => false))
        post :create, :yogo_project => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested yogo_project" do
        YogoProject.should_receive(:get).with("37").and_return(mock_yogo_project)
        mock_yogo_project.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :yogo_project => {:these => 'params'}
      end

      it "assigns the requested yogo_project as @yogo_project" do
        YogoProject.stub!(:get).and_return(mock_yogo_project(:update_attributes => true))
        put :update, :id => "1"
        assigns[:yogo_project].should equal(mock_yogo_project)
      end

      it "redirects to the yogo_project" do
        YogoProject.stub!(:get).and_return(mock_yogo_project(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(yogo_project_url(mock_yogo_project))
      end
    end

    describe "with invalid params" do
      it "updates the requested yogo_project" do
        YogoProject.should_receive(:get).with("37").and_return(mock_yogo_project)
        mock_yogo_project.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :yogo_project => {:these => 'params'}
      end

      it "assigns the yogo_project as @yogo_project" do
        YogoProject.stub!(:get).and_return(mock_yogo_project(:update_attributes => false))
        put :update, :id => "1"
        assigns[:yogo_project].should equal(mock_yogo_project)
      end

      it "re-renders the 'edit' template" do
        YogoProject.stub!(:get).and_return(mock_yogo_project(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested yogo_project" do
      YogoProject.should_receive(:get).with("37").and_return(mock_yogo_project)
      mock_yogo_project.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the yogo_projects list" do
      YogoProject.stub!(:get).and_return(mock_yogo_project(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(yogo_projects_url)
    end
  end

end
