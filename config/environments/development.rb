Idealme::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  config.eager_load = false

  # Show full error reports and disable caching
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  # begin
    config.middleware.use Rack::LiveReload
  # rescue Exception => e
  # end


  Paperclip::Attachment.default_options[:storage] = :s3
  Paperclip::Attachment.default_options[:s3_credentials] = {
    bucket: ENV['AWS_S3_BUCKET'],
    access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
  }
  Paperclip::Attachment.default_options[:s3_protocol] = :https

  config.action_mailer.default_url_options = {host: 'idealme.com'}
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    user_name: 'idealme-391cd542169169ce',
    password: 'aacad647af45183f',
    address: 'mailtrap.io',
    port: '2525',
    authentication: :plain
  }

end

AUTHORIZED_NET_GATEWAY = ActiveMerchant::Billing::AuthorizeNetGateway.new(login: ENV['AUTHORIZED_NET_LOGIN'], password: ENV['AUTHORIZED_NET_PASSWORD'], test: true)
# not used
#PAYPAL_GATEWAY = ActiveMerchant::Billing::PaypalGateway.new(login: ENV['PAYPAL_LOGIN'], password: ENV['PAYPAL_PASSWORD'], signature: ENV['PAYPAL_SIGNATURE'], test: true)
STRIPE_GATEWAY = ActiveMerchant::Billing::StripeGateway.new(login: ENV['STRIPE_SECRET_KEY'], test: true)
