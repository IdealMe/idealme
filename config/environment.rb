# Load the rails application
require File.expand_path('../application', __FILE__)

Paperclip::Attachment.default_options[:default_url] = '/missing/:class/:attachment/:style.png'

# Initialize the rails application
Idealme::Application.initialize!
