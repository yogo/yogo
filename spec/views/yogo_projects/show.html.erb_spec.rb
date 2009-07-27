require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/yogo_projects/show.html.erb" do
  include YogoProjectsHelper
  before(:each) do
    assigns[:yogo_project] = @yogo_project = stub_model(YogoProject)
  end

  it "renders attributes in <p>" do
    render
  end
end
