# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: pages_controller
# This controller loads static pages
#
class PagesController < ApplicationController
  rescue_from ActionView::MissingTemplate, :with => :invalid_page

  def show
    render params[:id]
  end

  def invalid_page
    redirect_to(:back)
  end
end