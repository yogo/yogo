class FeedbackController < ApplicationController
  
  before_filter :require_user
  #forge@msu.montana.edu
  def email
    Pony.mail(:to => 'forge@msu.montana.edu', 
              :subject => params[:subject], 
              :body => "Project: epscor-sensor\nTracker: feedback\n"+params[:body], 
              :via => :smtp, 
              :via_options => 
              {
                :address => 'smtp.gmail.com', 
                :port => '587',
                :enable_starttls_auto => true,
                :user_name => 'voeis.mgmt@gmail.com',
                :password => 'V0eisD3mo',
                :authentication => :plain, 
                :domain => "localhost.localdomain"
              }
    )
  end
end