# Load the rails application
require File.expand_path('../application', __FILE__)

Paperclip::Attachment.default_options[:default_url] = '/missing/:class/:attachment/:style.png'


#idealme
#ralphy28E!

#app17989773@heroku.com
#akp8nwdl


ENV['AWS_CF_KEY_PAIR_ID'] = 'APKAIS27M4HGDLWDGQAQ'
ENV['AWS_ACCESS_KEY_ID'] = 'AKIAJLDIGUPMHU2FYWPA'
ENV['AWS_SECRET_ACCESS_KEY'] = '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'

ENV['SENDGRID_API_USERNAME'] = 'idealmeinc.api'
ENV['SENDGRID_API_PASSWORD'] = 'hJ4OjnmrYew8EjE'

if Rails.env.production?
  ENV['FACEBOOK_API_KEY'] = '278115168965598'
  ENV['FACEBOOK_API_SECRET'] = '2a65c5c71ef87ce68fd1dfb965d0934a'
  #ENV['AWS_S3_BUCKET'] = 'idealme-prod'
  #ENV['AWS_S3_ASSET_BUCKET'] = 'idealme-prod-assets'
  #ENV['AWS_CF_STREAMING'] = "rtmp://streaming.ideal.me/cfx/st"
  #ENV['AWS_CF_ASSET'] = '//d1oi23ayjzl9lh.cloudfront.net'
  #ENV['PAYPAL_ACCOUNT'] = 'brittany@brittanylynch.com'
  #ENV['PAYPAL_CERT_ID'] = 'L953RJR7MRADC'
  #ENV['PAYPAL_POST_URL'] = 'https://www.paypal.com/cgi-bin/webscr'
elsif Rails.env.staging?
  ENV['FACEBOOK_API_KEY'] = '407719212622205'
  ENV['FACEBOOK_API_SECRET'] = '4eec57cdef43a2b5c3bf99a5e63ae14a'
  #ENV['AWS_S3_BUCKET'] = 'idealme-stage'
  #ENV['AWS_S3_ASSET_BUCKET'] = 'idealme-stage-assets'
  #ENV['AWS_CF_STREAMING'] = 'rtmp://s3a7eohta229p4.cloudfront.net/cfx/st'
  #ENV['AWS_CF_ASSET'] = '//d3awp6qor11omf.cloudfront.net'
elsif Rails.env.development?
  ENV['FACEBOOK_API_KEY'] = '230769680405348'
  ENV['FACEBOOK_API_SECRET'] = 'edc8a8c0a757f768fcf062a1352fcce2'

  ENV['GOOGLE_API_KEY'] = '230865568543.apps.googleusercontent.com'
  ENV['GOOGLE_API_SECRET'] ='HVV6T2KCCafYjIeiR0JS8A_S'

  ENV['YAHOO_API_KEY'] = 'dj0yJmk9eW04UzZxTGlLTUtqJmQ9WVdrOVpuWmFSMFEyTXpBbWNHbzlNakV5TVRNeE9USTJNZy0tJnM9Y29uc3VtZXJzZWNyZXQmeD05Nw--'
  ENV['YAHOO_API_SECRET'] ='3d48cfe2cd85c8db8cfa7d279c4a00f5728c462f'
  #
  #ENV['AWS_S3_BUCKET'] = 'idealme-dev'
  #ENV['AWS_S3_ASSET_BUCKET'] = 'idealme-dev-assets'
  #ENV['AWS_CF_STREAMING'] = 'rtmp://s16fvel75z8ykf.cloudfront.net/cfx/st'
  #ENV['AWS_CF_ASSET'] = '//d3awp6qor11omf.cloudfront.net'
end

unless Rails.env.production?
  ActionMailer::Base.smtp_settings = {
    :address        => 'smtp.sendgrid.net',
    :port           => '587',
    :authentication => :plain,
    :user_name      => ENV['SENDGRID_USERNAME'],
    :password       => ENV['SENDGRID_PASSWORD'],
    :domain         => 'heroku.com',
    :enable_starttls_auto => true
  }
  
  #ENV['PAYPAL_POST_URL'] = 'https://www.sandbox.paypal.com/cgi-bin/webscr'
  #ENV['PAYPAL_ACCOUNT'] = 'bill-facilitator@idealme.com'
  #ENV['PAYPAL_CERT_ID'] = 'UGNF3J2XZRN7Y'



  #ENV['STRIPE_SECRET_KEY'] = 'sk_test_0YBVMBWJ7IjlAjQHnZUWmAoN'
  #ENV['STRIPE_PUBLIC_KEY'] = 'pk_test_Z4UtHr3ItSYWAbFAvfNjCCDO'

  
  #ActiveMerchant::Billing::Base.mode = :test
  #ActiveMerchant::Billing::Base.gateway_mode = :test
  #ActiveMerchant::Billing::Base.integration_mode = :test
end



# Initialize the rails application
Idealme::Application.initialize!
