ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address => 'smtp.gmail.com', 
  :port => '587',
  :enable_starttls_auto => true,
  :user_name => 'voeis.mgmt@gmail.com',
  :password => 'V0eisD3mo',
  :authentication => :plain, 
  :domain => "localhost.localdomain"
}

# ActionMailer::Base.default_url_options[:host] = "localhost:3000"
# Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?
