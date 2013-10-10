# Load the rails application
require File.expand_path('../application', __FILE__)

Paperclip::Attachment.default_options[:default_url] = '/missing/:class/:attachment/:style.png'
Paperclip::Attachment.default_options[:storage] = :s3
Paperclip::Attachment.default_options[:s3_credentials] = {
  :bucket => ENV['AWS_S3_BUCKET'],
  :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
  :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
}

#idealme
#ralphy28E!

#app17989773@heroku.com
#akp8nwdl

# Initialize the rails application
Idealme::Application.initialize!

ActionMailer::Base.smtp_settings = {
  :address        => 'smtp.sendgrid.net',
  :port           => '587',
  :authentication => :plain,
  :user_name      => ENV['SENDGRID_API_USERNAME'],
  :password       => ENV['SENDGRID_API_PASSWORD'],
  :domain         => 'heroku.com',
  :enable_starttls_auto => true
}

unless Rails.env.production?  
  #ActiveMerchant::Billing::Base.mode = :test
  #ActiveMerchant::Billing::Base.gateway_mode = :test
  #ActiveMerchant::Billing::Base.integration_mode = :test
end