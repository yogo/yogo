require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/yogo_projects/new.html.erb" do
  include YogoProjectsHelper

  before(:each) do
    assigns[:yogo_project] = stub_model(YogoProject).as_new_record
  end

  it "renders new yogo_project form" do
    render

    response.should have_tag("form[action=?][method=post]", yogo_projects_path) do
    end
  end
end
