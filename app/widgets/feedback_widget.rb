class FeedbackWidget < Apotomo::Widget
  responds_to_event :submit, :with => :process_feedback
  helper ApplicationHelper
  include RailsWarden::Mixins::HelperMethods
  
  def display
    render
  end
  
  def process_feedback 
    if !current_user.nil?
      logger.debug {"Sending an Email."}
      VoeisMailer.email_forge(current_user.name+':'+params[:issue_subject],"Project: epscor-sensor\nTracker: feedback\n"+params[:issue_body])
    else
      #do nothing
    end
    replace :view => :display
  end

end
