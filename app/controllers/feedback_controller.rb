class FeedbackController < ApplicationController

  #forge@msu.montana.edu
  def email
    VoeisMailer.email_forge(params[:feedback][:issue_subject],"Project: epscor-sensor\nTracker: feedback\n"+params[:feedback][:issue_body])
    respond_to do |format|
      format.js 
    end
  end
  
  def nothing
    #do nothing
  end
end