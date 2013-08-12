require 'cloudfront-signer'

AWS::CF::Signer.configure do |config|
  config.key_path = "#{Rails.root}/certs/cloudfront_production_private.pem"
  config.key_pair_id = ENV['AWS_CF_KEY_PAIR_ID']
  config.default_expires = 3600
end