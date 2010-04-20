class MockupController < ApplicationController

  # View for the mockup
  #
  # @example http://localhost:3000/mockup/
  #
  # @return [Webpage] renders webpage
  #
  # @author Yogo Team
  #
  # @api public  
  def index
    render :layout => 'mockup'
  end

end
