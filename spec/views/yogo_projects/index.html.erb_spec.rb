require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/yogo_projects/index.html.erb" do
  include YogoProjectsHelper

  before(:each) do
    assigns[:yogo_projects] = [
      stub_model(YogoProject),
      stub_model(YogoProject)
    ]
  end

  it "renders a list of yogo_projects" do
    render
  end
end
