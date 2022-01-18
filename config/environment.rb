# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.smtp_settings = {
  user_name: 'apikey', 
  password:  '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',
  domain: 'library-main.herokuapp.com',
  address: 'smtp.sendgrid.net',
  port: 587,
  authentication: :plain,
  enable_starttls_auto: true
}

