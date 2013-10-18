# Load the rails application
require File.expand_path('../application', __FILE__)

Paperclip::Attachment.default_options[:default_url] = '/missing/:class/:attachment/:style.png'

#app17989773@heroku.com
#akp8nwdl

# Initialize the rails application
Idealme::Application.initialize!



unless Rails.env.production?
  #ActiveMerchant::Billing::Base.mode = :test
  #ActiveMerchant::Billing::Base.gateway_mode = :test
  #ActiveMerchant::Billing::Base.integration_mode = :test
end