require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/yogo_projects/edit.html.erb" do
  include YogoProjectsHelper

  before(:each) do
    assigns[:yogo_project] = @yogo_project = stub_model(YogoProject)
  end

  it "renders the edit yogo_project form" do
    render

    response.should have_tag("form[action=#{yogo_project_path(@yogo_project)}][method=post]") do
    end
  end
end
