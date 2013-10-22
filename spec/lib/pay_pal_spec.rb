require 'spec_helper'

describe PayPal do

  describe "#get_token" do
    it 'gets a token from paypal' do
      VCR.use_cassette('paypal_get_token') do
        paypal = PayPal.new
        token = paypal.get_token
      end
    end
  end

  describe "#create_payment" do
    it 'creates a payment' do
      VCR.use_cassette('paypal_create_payment') do
        paypal = PayPal.new
        payment = paypal.create_payment('19.99', 'You sure love the internet!')
        expect(paypal.approval_url).to eq 'https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=EC-7XA82522G8059463P'
      end

    end
  end

end
