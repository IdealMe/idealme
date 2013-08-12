require 'action_pack'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module ActionViewHelper
        def paypal_payment_service_for(order, account, options = {}, &proc)
          raise ArgumentError, "Missing block" unless block_given?
          integration_module = ActiveMerchant::Billing::Integrations.const_get(options.delete(:service).to_s.camelize)
          encrypt = options.delete(:encrypt)
          result = []
          result << form_tag(integration_module.service_url, options.delete(:html) || {})
          service_class = integration_module.const_get('Helper')
          service = service_class.new(order, account, options)
          result << capture(service, &proc)
          if encrypt
            paypal_params = {:cert_id => ENV['PAYPAL_CERT_ID']}
            service.form_fields.each do |field, value|
              paypal_params.merge!(field => value)
            end
            result << hidden_field_tag(:cmd, "_s-xclick")
            result << "\n"
            result << hidden_field_tag(:encrypted, encrypt_for_paypal(paypal_params))
          else
            service.form_fields.each do |field, value|
              result << hidden_field_tag(field, value)
            end
          end
          result << '</form>'
          result= result.join("\n")
          concat(result.respond_to?(:html_safe) ? result.html_safe : result)
          nil
        end

        # encrypt values
        def encrypt_for_paypal(values)
          if ActiveMerchant::Billing::Base.test?
            app_cert_pem = File.read("#{Rails.root}/certs/app_t_public.pem")
            app_key_pem = File.read("#{Rails.root}/certs/app_t_private.pem")
            paypal_cert_pem = File.read("#{Rails.root}/certs/paypal_t_public.pem")
          else
            app_cert_pem = File.read("#{Rails.root}/certs/app_p_public.pem")
            app_key_pem = File.read("#{Rails.root}/certs/app_p_private.pem")
            paypal_cert_pem = File.read("#{Rails.root}/certs/paypal_p_public.pem")
          end
          signed = OpenSSL::PKCS7::sign(OpenSSL::X509::Certificate.new(app_cert_pem), OpenSSL::PKey::RSA.new(app_key_pem, ''), values.map { |k, v| "#{k}=#{v}" }.join("\n"), [], OpenSSL::PKCS7::BINARY)
          OpenSSL::PKCS7::encrypt([OpenSSL::X509::Certificate.new(paypal_cert_pem)], signed.to_der, OpenSSL::Cipher::Cipher::new("DES3"), OpenSSL::PKCS7::BINARY).to_s.gsub("\n", "")
        end
      end
    end
  end
end
