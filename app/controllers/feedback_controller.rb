class FeedbackController < ApplicationController

  #forge@msu.montana.edu
  def email
    if !current_user.nil?
      VoeisMailer.email_forge(current_user.name+':'+params[:feedback][:issue_subject],"Project: epscor-sensor\nTracker: feedback\n"+params[:feedback][:issue_body])
      respond_to do |format|
        format.js 
      end
    else
      #do nothing
    end
  end
  
  def nothing
    #do nothing
  end
end