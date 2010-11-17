class VoeisMailer < ActionMailer::Base
    default :from => 'voeis.mgmt@gmail.com'
  #forge@msu.montana.edu
  def email_forge(subject, body)
    puts "Im emailing"
    mail(:to => 'forge@msu.montana.edu', 
         :subject => subject, 
         :body => body ).deliver
  end
end