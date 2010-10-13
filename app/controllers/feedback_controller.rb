class FeedbackController < ApplicationController
  
  before_filter :require_user
  
  def email
    Pony.mail(:to => 'epscor-sensor-feedback@montana.edu', 
              :subject => params[:subject], 
              :body => params[:body], 
              :via => :smtp, 
              :via_options => 
              {
                :address => 'smtp.gmail.com', 
                :port => '587',
                :enable_starttls_auto => true,
                :user_name => 'voeis.mgmt@gmail.com',
                :password => '',
                :authentication => :plain, 
                :domain => "localhost.localdomain"
              }
    )
  end
end