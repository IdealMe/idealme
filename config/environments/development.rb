Idealme::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  config.action_mailer.delivery_method = :smtp

  config.action_mailer.smtp_settings = {
      :user_name => 'ideal-me-development',
      :password => '24eedef449ddd0e2',
      :address => 'mailtrap.io',
      :port => '2525',
      :authentication => :plain,
  }
  config.action_mailer.default_url_options = {:host => 'idealme.dev'}

end

#
#Paperclip::Attachment.default_options[:bucket] = ENV['AWS_S3_BUCKET']
#Paperclip::Attachment.default_options[:storage] = :s3
#Paperclip::Attachment.default_options[:s3_credentials] = {:access_key_id => ENV['AWS_ACCESS_KEY_ID'], :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']}
#Paperclip::Attachment.default_options[:s3_protocol] = 'https'
#Paperclip::Attachment.default_options[:s3_permissions] = :public_read


AUTHORIZED_NET_GATEWAY = ActiveMerchant::Billing::AuthorizeNetGateway.new(:login => '5zKG6HaL25f4', :password => '2eMsq3rD3kH266Nc', :test => true)
PAYPAL_GATEWAY = ActiveMerchant::Billing::PaypalGateway.new(:login => 'bill_1351753306_biz_api1.ideal.me', :password => '1351753374', :signature => 'ABWxvXq5fyKjoekNasQ5QgN7l9NIAHOqW7kZJjH7atwVshi-4E178qmb', :test => true)