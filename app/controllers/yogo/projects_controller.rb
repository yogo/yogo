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
  belongs_to :role, :user, :optional => true

  ##
  # Show all the projects
  #
  # @example 
  #   get /projects
  #
  # @return [Array] Retrives all project and passes them to the view
  #
  # @author Yogo Team
  #
  # @api public
  def index
    super do |format|
      if collection.empty?
        @no_search = true
        @no_menu   = true 
        format.html { render('no_projects') }
      else
        format.html 
      end
    end
  end
  
  def destroy
    destroy! do |success,failure|
      success.html { redirect_to( yogo_projects_path )}
    end
  end
  
  protected

  def resource
    @project ||= resource_class.get(params[:id])
  end
  
  def collection
    @projects ||= resource_class.all # .paginate(:page => params[:page], :per_page => 5)
  end
  
  def resource_class
    Yogo::Project.access_as(current_user)
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
