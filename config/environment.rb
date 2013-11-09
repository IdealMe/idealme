# Load the Rails application.
require File.expand_path('../application', __FILE__)

Paperclip::Attachment.default_options[:default_url] = '/missing/:class/:attachment/:style.png'

# Initialize the Rails application.
Idealme::Application.initialize!
