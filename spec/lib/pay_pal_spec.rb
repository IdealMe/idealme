require 'spec_helper'

describe PayPal do

  describe "#get_token" do
    it 'gets a token from paypal' do
      VCR.use_cassette('paypal_get_token') do
        paypal = PayPal.new(ENV['IDEALME_PAYPAL_ENDPOINT'], [ ENV['IDEALME_PAYPAL_AUTH_KEY'], ENV['IDEALME_PAYPAL_AUTH_SECRET'] ])
        token = paypal.get_token
      end
    end
  end

  describe "#create_payment" do
    it 'creates a payment' do
      VCR.use_cassette('paypal_create_payment') do
        paypal = PayPal.new(ENV['IDEALME_PAYPAL_ENDPOINT'], [ ENV['IDEALME_PAYPAL_AUTH_KEY'], ENV['IDEALME_PAYPAL_AUTH_SECRET'] ])
        payment = paypal.create_payment('19.99', 'You sure love the internet!', 'https://idealme.com/paypal-return', 'https://idealme.com/paypal-cancel')
        expect(paypal.approval_url).to include 'https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token='
      end
    end

  end



end
