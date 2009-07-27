require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe YogoProjectsController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "yogo_projects", :action => "index").should == "/yogo_projects"
    end

    it "maps #new" do
      route_for(:controller => "yogo_projects", :action => "new").should == "/yogo_projects/new"
    end

    it "maps #show" do
      route_for(:controller => "yogo_projects", :action => "show", :id => "1").should == "/yogo_projects/1"
    end

    it "maps #edit" do
      route_for(:controller => "yogo_projects", :action => "edit", :id => "1").should == "/yogo_projects/1/edit"
    end

    it "maps #create" do
      route_for(:controller => "yogo_projects", :action => "create").should == {:path => "/yogo_projects", :method => :post}
    end

    it "maps #update" do
      route_for(:controller => "yogo_projects", :action => "update", :id => "1").should == {:path =>"/yogo_projects/1", :method => :put}
    end

    it "maps #destroy" do
      route_for(:controller => "yogo_projects", :action => "destroy", :id => "1").should == {:path =>"/yogo_projects/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/yogo_projects").should == {:controller => "yogo_projects", :action => "index"}
    end

    it "generates params for #new" do
      params_from(:get, "/yogo_projects/new").should == {:controller => "yogo_projects", :action => "new"}
    end

    it "generates params for #create" do
      params_from(:post, "/yogo_projects").should == {:controller => "yogo_projects", :action => "create"}
    end

    it "generates params for #show" do
      params_from(:get, "/yogo_projects/1").should == {:controller => "yogo_projects", :action => "show", :id => "1"}
    end

    it "generates params for #edit" do
      params_from(:get, "/yogo_projects/1/edit").should == {:controller => "yogo_projects", :action => "edit", :id => "1"}
    end

    it "generates params for #update" do
      params_from(:put, "/yogo_projects/1").should == {:controller => "yogo_projects", :action => "update", :id => "1"}
    end

    it "generates params for #destroy" do
      params_from(:delete, "/yogo_projects/1").should == {:controller => "yogo_projects", :action => "destroy", :id => "1"}
    end
  end
end
