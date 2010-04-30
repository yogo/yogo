class DashboardController < ApplicationController

  # The root of the website
  # 
  # @example 
  #   get / or get /dashboard
  #
  # @return [Webpage] renders webpage
  #
  # @author Yogo Team
  #
  # @api public
  #   
  def index
    @no_search = true
    @projects = Project.paginate(:page => params[:page], :per_page => 5)

    respond_to do |format|
      if @projects.empty?
        format.html { render('no_projects') }
      else
        format.html 
      end
    end
  end

end
