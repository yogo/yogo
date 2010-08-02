require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

#
# This should have all the basic CRUD tests, plus anything the controller is doing special
#
describe Yogo::DataController do

  def mock_project(stubs={})
    @mock_project ||= begin 
                        @mock_project = mock_model(Project, stubs)
                        @mock_project.stub!(:get_model).with('Vanilla').and_return(mock_yogo_model)
                        @mock_project.stub!(:namespace).and_return("TestProject")  
                        @mock_project
                      end
  end

  def mock_yogo_model
    @mock_query ||= mock('YogoModelQuery', :paginate => [])
    @mock_model ||= mock('YogoModel', :all => @mock_query, :new => mock_yogo_data )
  end

  def mock_yogo_data
    @mock_data ||= mock('YogoData')
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
      Setting[:local_only] = true
    end
    
    it "should be local only" do
      Setting[:local_only].should be_true
    end
    
    describe 'GET' do
      it "should allow a get" do
        Project.stub!(:get).with("42").and_return(mock_project)

        get( :index, :project_id => "42", :model_id => 'Vanilla' )

        response.should be_success
        response.should_not be_redirect

        assigns[:project].should eql mock_project
        assigns[:model].should eql mock_yogo_model
        assigns[:query].should_not be_nil
      end

      it "should allow getting a specific item" do
        Project.stub!(:get).with("42").and_return(mock_project)
        mock_yogo_model.stub!(:get).with('3').and_return(mock_yogo_data)

        get(:show, :project_id => "42", :model_id => 'Vanilla', :id => '3')

        assigns[:item].should eql mock_yogo_data
        response.should be_success
        response.should_not be_redirect
      end

      it "should allow getting a 'new' form" do
        Project.stub!(:get).with("42").and_return(mock_project)


        get(:new, :project_id => "42", :model_id => "Vanilla")
        assigns[:item].should eql mock_yogo_data
        response.should be_success
        response.should_not be_redirect
      end

      it "should allow editing an existing item" do
        Project.stub!(:get).with("42").and_return(mock_project)

        mock_yogo_model.stub!(:get).with('3').and_return(mock_yogo_data)

        get(:edit, :project_id => "42", :model_id => 'Vanilla', :id => '3')

        assigns[:item].should eql mock_yogo_data
        response.should be_success
        response.should_not be_redirect
        response.should render_template('edit')
      end
    end # GET tests

    describe 'POST' do
      it "should allow posting a new valid item" do
        Project.stub!(:get).with("42").and_return(mock_project(:namespace => 'TestProject'))

        mock_yogo_model.stub!(:name).and_return('Yogo::TestProject::Vanilla')
        mock_yogo_data.stub!(:valid?).and_return(true)
        mock_yogo_data.stub!(:save).and_return(true)
        
        post(:create, :project_id => "42", :model_id => "Vanilla", :yogo_test_project_vanilla => {'this' => 'item' })

        response.should redirect_to(project_yogo_data_index_url(mock_project, "Vanilla"))
      end

      it "should not allow posing a new invalid item" do
        Project.stub!(:get).with("42").and_return(mock_project(:namespace => 'TestProject'))
        
        mock_yogo_model.stub!(:name).and_return('Yogo::TestProject::Vanilla')
        mock_yogo_data.stub!(:valid?).and_return(false)
        mock_yogo_data.stub!(:save).and_return(true)
        
        post(:create, :project_id => "42", :model_id => "Vanilla", :yogo_test_project_vanilla => {'this' => 'item' })

        response.should render_template('new')
      end
      
    end # POST tests
        
    describe 'PUT' do
      it "should update a prject with valid data" do
        Project.stub!(:get).with("42").and_return(mock_project(:namespace => 'TestProject'))
        
        mock_yogo_model.stub!(:name).and_return('Yogo::TestProject::Vanilla')
        mock_yogo_model.stub!(:get).with('13').and_return(mock_yogo_data)
        mock_yogo_data.stub!(:attributes=).with('this'=>'item').and_return('monsters!')
        mock_yogo_data.stub!(:valid?).and_return(true)
        mock_yogo_data.stub!(:save).and_return(true)
        
        put(:update, :project_id => "42", :model_id => "Vanilla", :id => '13',:yogo_test_project_vanilla => {'this' => 'item' })
        
        response.should redirect_to(project_yogo_data_index_url(mock_project, "Vanilla"))
      end

      it "should not update a prject with invalid data" do
        Project.stub!(:get).with("42").and_return(mock_project(:namespace => 'TestProject'))
        
        mock_yogo_model.stub!(:name).and_return('Yogo::TestProject::Vanilla')
        mock_yogo_model.stub!(:get).with('13').and_return(mock_yogo_data)
        mock_yogo_data.stub!(:attributes=).with('this'=>'item').and_return('monsters!')
        mock_yogo_data.stub!(:valid?).and_return(false)
        mock_yogo_data.stub!(:save).and_return(false)
        
        put(:update, :project_id => "42", :model_id => "Vanilla", :id => '13',:yogo_test_project_vanilla => {'this' => 'item' })
        
        response.should render_template('edit')
      end

    end # PUT tests
    
    describe 'DELETE' do
      it "should delete a data item" do
        Project.stub!(:get).with("42").and_return(mock_project(:namespace => 'TestProject'))
        
        mock_yogo_model.stub!(:name).and_return('Yogo::TestProject::Vanilla')
        mock_yogo_model.stub!(:get).with('13').and_return(mock_yogo_data)

        mock_yogo_data.stub!(:destroy).and_return(true)
        
        delete(:destroy, :project_id => "42", :model_id => "Vanilla", :id => '13')

        response.should redirect_to(project_yogo_data_index_url(mock_project, "Vanilla"))
      end
    end # DELETE tests
  end # Describe running locally

  describe "when running as a server" do
    before(:all) do
      Setting[:local_only] = false
    end
    
    it "should be local only" do
      Setting[:local_only].should be_false
    end
    
    describe "when not logged in" do
      before(:each) do
        request.env["warden"].stub!(:authenticated?).and_return(false)
      end
    
      describe 'GET' do
        it "should allow access to public projects data" do
          Project.stub!(:get).with("42").and_return(mock_project)
          mock_project.stub!(:is_private?).and_return(false)

          get( :index, :project_id => "42", :model_id => 'Vanilla' )

          response.should be_success
          response.should_not be_redirect

          assigns[:project].should eql mock_project
          assigns[:model].should eql mock_yogo_model
          assigns[:query].should_not be_nil
        end
        
        it "should not allow access to private projects data" do
          Project.stub!(:get).with("42").and_return(mock_project)
          mock_project.stub!(:is_private?).and_return(true)

          get( :index, :project_id => "42", :model_id => 'Vanilla' )

          response.should be_redirect
          response.should redirect_to(login_url)
        end
        
        it "should allow access to public projects" do
          Project.stub!(:get).with("42").and_return(mock_project)
          mock_project.stub!(:is_private?).and_return(false)
          mock_yogo_model.stub!(:get).with('3').and_return(mock_yogo_data)
          
          get( :show, :project_id => "42", :model_id => 'Vanilla', :id => '3' )

          response.should be_success
          response.should_not be_redirect

          assigns[:project].should eql mock_project
          assigns[:model].should eql mock_yogo_model
          assigns[:item].should eql mock_yogo_data
        end
        
        it "should not allow access to private projects" do
          Project.stub!(:get).with("42").and_return(mock_project)
          mock_project.stub!(:is_private?).and_return(true)

          get( :index, :project_id => "42", :model_id => 'Vanilla', :id => '13' )

          response.should be_redirect
          response.should redirect_to(login_url)
        end
        
        it "should not allow access to the new form" do
          Project.stub!(:get).with("42").and_return(mock_project)
          mock_project.stub!(:is_private?).and_return(false)
          get(:new, :project_id => "42", :model_id => "Vanilla")
          
          response.should be_redirect
          response.should redirect_to(login_url)
        end
        
        it "should not allow access to the edit form" do
          Project.stub!(:get).with("42").and_return(mock_project)
          mock_project.stub!(:is_private?).and_return(false)
          get(:new, :project_id => "42", :model_id => "Vanilla", :id => 13)
          
          response.should be_redirect
          response.should redirect_to(login_url)
        end
      end
    end
    
    describe "when logged in" do
      before(:each) do
        User.all.destroy
        @u = standard_user
        @u.save
        request.env["warden"].stub!(:user).and_return(@u)
        request.env["warden"].stub!(:authenticated?).and_return(true)
      end
      
      describe "GET" do
        it "should allow access to public projects the user doesn't belongs to" do
          @u.stub!(:is_in_project?).and_return(false)
          Project.stub!(:get).with("42").and_return(mock_project(:models => [], :is_private? => false))

          get( :index, :project_id => "42", :model_id => 'Vanilla' )

          response.should be_success
          response.should_not be_redirect
          response.should render_template('index')
        end
        
        it "should allow access to private project the user belongs to" do
          @u.stub!(:is_in_project?).and_return(true)
          Project.stub!(:get).with("42").and_return(mock_project(:models => [], :is_private? => true))
        
          get( :index, :project_id => "42", :model_id => 'Vanilla' )

          response.should be_success
          response.should_not be_redirect
          response.should render_template('index')
        end
      
        it "should not allow access to a private project the user doesn't belongs to" do
          @u.stub!(:is_in_project?).and_return(false)
          Project.stub!(:get).with("42").and_return(mock_project(:models => [], :is_private? => true))
        
          get( :index, :project_id => "42", :model_id => 'Vanilla' )

          response.should be_redirect
          response.should_not redirect_to(login_url)
        end
        
        
        it "should allow access to public projects data items the user doesn't belongs to" do
          @u.stub!(:is_in_project?).and_return(false)
          Project.stub!(:get).with("42").and_return(mock_project(:models => [], :is_private? => false))
          mock_yogo_model.stub!(:get).with('13').and_return(mock_yogo_data)

          get( :show, :project_id => "42", :model_id => 'Vanilla', :id => '13' )

          response.should be_success
          response.should_not be_redirect
          response.should render_template('show')
        end
        
        it "should allow access to private project data items the user belongs to" do
          @u.stub!(:is_in_project?).and_return(true)
          Project.stub!(:get).with("42").and_return(mock_project(:models => [], :is_private? => true))
          mock_yogo_model.stub!(:get).with('13').and_return(mock_yogo_data)
        
          get( :show, :project_id => "42", :model_id => 'Vanilla', :id => '13' )

          response.should be_success
          response.should_not be_redirect
        end
      
        it "should not allow access to a private project data items the user doesn't belongs to" do
          Project.stub!(:get).with("42").and_return(mock_project(:models => [], :is_private? => true))
          @u.stub!(:is_in_project?).with(mock_project).and_return(false)
          mock_yogo_model.stub!(:get).with('13').and_return(mock_yogo_data)
        
          get( :show, :project_id => '42', :model_id => 'Vanilla', :id => '13' )

          response.should be_redirect
          response.should_not render_template("show")
          response.should_not redirect_to(login_url)
        end

        it "should allow access to the new form when the user is a member of the project" do
          Project.stub!(:get).with("42").and_return(mock_project(:models => [], :is_private? => true))
          @u.stub!(:has_permission?).with(:edit_model_data,mock_project).and_return(true)

          get(:new, :project_id => '42', :model_id => 'Vanilla')
          response.should be_success
          response.should render_template('new')
          assigns[:item].should eql mock_yogo_data
        end

        it "should not allow access to the new form when the user is not a member of the project" do
          Project.stub!(:get).with("42").and_return(mock_project(:models => [], :is_private? => true))
          @u.stub!(:has_permission?).with(:edit_model_data,mock_project).and_return(false)

          get(:new, :project_id => '42', :model_id => 'Vanilla')
          response.should be_redirect
          response.should_not render_template("new")
        end

        it "should not allow access to the new form when the user is not a member of the project, even if the project is public" do
          Project.stub!(:get).with("42").and_return(mock_project(:models => [], :is_private? => false))
          @u.stub!(:has_permission?).with(:edit_model_data,mock_project).and_return(false)

          get(:new, :project_id => '42', :model_id => 'Vanilla')
          response.should be_redirect
          response.should_not render_template("new")
        end
        
      end # GET actions

      describe "POST" do
        it "should allow creating a new item when the user has permission" do
          Project.stub!(:get).with("42").and_return(mock_project(:models => [], :is_private? => false))
          @u.stub!(:has_permission?).and_return(true)

          mock_yogo_model.stub!(:name).and_return('Yogo::TestProject::Vanilla')
          mock_yogo_data.stub!(:valid?).and_return(true)
          mock_yogo_data.stub!(:save).and_return(true)
          # debugger
          post(:create, :project_id => "42", :model_id => "Vanilla", :yogo_test_project_vanilla => {'this' => 'item' })

          response.should redirect_to(project_yogo_data_index_url(mock_project, "Vanilla"))         
        end

        it "should now allow the creation of a new item if the user does not have permission" do
          Project.stub!(:get).with("42").and_return(mock_project(:models => [], :is_private? => false))
          @u.stub!(:has_permission?).and_return(false)

          mock_yogo_model.stub!(:name).and_return('Yogo::TestProject::Vanilla')
          mock_yogo_data.stub!(:valid?).and_return(true)
          mock_yogo_data.stub!(:save).and_return(true)
          # debugger
          post(:create, :project_id => "42", :model_id => "Vanilla", :yogo_test_project_vanilla => {'this' => 'item' })

          response.should be_redirect
          response.should_not redirect_to(login_url)
        end
      end

      describe "PUT" do
        it "should update a prject when the user has permission" do
          Project.stub!(:get).with("42").and_return(mock_project(:namespace => 'TestProject', :is_private? => true))
          @u.stub!(:has_permission?).and_return(true)
          
          mock_yogo_model.stub!(:name).and_return('Yogo::TestProject::Vanilla')
          mock_yogo_model.stub!(:get).with('13').and_return(mock_yogo_data)
          mock_yogo_data.stub!(:attributes=).with('this'=>'item').and_return('monsters!')
          mock_yogo_data.stub!(:valid?).and_return(true)
          mock_yogo_data.stub!(:save).and_return(true)
          
          put(:update,
              :project_id => "42",
              :model_id => "Vanilla",
              :id => '13',
              :yogo_test_project_vanilla => {'this' => 'item' })
          response.should redirect_to(project_yogo_data_index_url(mock_project, "Vanilla"))
        end

        it "should not update a project when the user doesn't have permission" do
          Project.should_receive(:get).with("42").and_return(mock_project(:namespace => 'TestProject', :is_private? => true))
          @u.stub!(:has_permission?).and_return(false)
          
          mock_yogo_model.stub!(:name).and_return('Yogo::TestProject::Vanilla')
          mock_yogo_model.stub!(:get).with('13').and_return(mock_yogo_data)
          # mock_yogo_data.should_not_recieve(:attributes=)
          mock_yogo_data.should_not_receive(:valid?)
          mock_yogo_data.should_not_receive(:save)
          
          put(:update,
              :project_id => "42",
              :model_id => "Vanilla",
              :id => '13',
              :yogo_test_project_vanilla => {'this' => 'item' })
          response.should be_redirect
          response.should_not redirect_to(login_url)
        end
      end

      describe "DELETE" do
        it "should delete a data item if the user has permissioin" do
          Project.stub!(:get).with("42").and_return(mock_project(:namespace => 'TestProject', :is_private? => true))
          @u.should_receive(:has_permission?).and_return(true)
          mock_yogo_model.stub!(:name).and_return('Yogo::TestProject::Vanilla')
          mock_yogo_model.stub!(:get).with('13').and_return(mock_yogo_data)

          mock_yogo_data.should_receive(:destroy).and_return(true)
          
          delete(:destroy, :project_id => "42", :model_id => "Vanilla", :id => '13')
          
          response.should redirect_to(project_yogo_data_index_url(mock_project, "Vanilla"))
        end

        it "should not delete a data item if the user does not have permissioin" do
          Project.stub!(:get).with("42").and_return(mock_project(:namespace => 'TestProject', :is_private? => true))
          @u.should_receive(:has_permission?).and_return(false)
          mock_yogo_model.stub!(:name).and_return('Yogo::TestProject::Vanilla')
          mock_yogo_model.stub!(:get).with('13').and_return(mock_yogo_data)
          
          mock_yogo_data.should_not_receive(:destroy).and_return(true)
          
          delete(:destroy, :project_id => "42", :model_id => "Vanilla", :id => '13')
          
          response.should_not redirect_to(project_yogo_data_index_url(mock_project, "Vanilla"))
          response.should be_redirect
          response.should_not redirect_to(login_url)
        end
      end
    end # When logged in
  end # When in server mode
end # YogoDataController

