class DashboardController < ApplicationController

  # @example http://localhost:3000/mockup/
  #
  # @return [Webpage] renders webpage
  #
  # @author Yogo Team
  #
  # @api public  
  def index
    #todo PAGINATE
    @projects = Project.all
    
    respond_to do |format|
      if @projects.empty?
        format.html { render('no_projects') }
      else
        format.html 
      end
    end
  end

end
