# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: projects_controller.rb
# The projects controller provides all the CRUD functionality for the project
# and additionally: upload of CSV files, an example project and rereflection
# of the yogo repository.

class Yogo::ProjectsController < Yogo::BaseController
  defaults :resource_class => Yogo::Project,
           :collection_name => 'projects',
           :instance_name => 'project'

  belongs_to :role, :user, :optional => true

  def destroy
    destroy! do |success, failure|
      success.html { redirect_to(yogo_projects_path) }
    end
  end

  protected

  def resource
    @project ||= collection.get(params[:id])
  end

  def collection
    @projects ||= resource_class.all
  end

  def resource_class
    Yogo::Project
  end

  with_responder do
    def resource_json(project)
      hash = super(project)
      hash[:data_collections] = project.data_collections.map do |c|
        controller.send(:yogo_project_collection_path, project, c)
      end
      hash
    end
  end
end
