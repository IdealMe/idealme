require 'spec_helper'

describe LandingsController do

  describe "purchase_continuity_offer" do

    let(:user)          { create(:user) }
    before :each do
      sign_in user

      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      token = Stripe::Token.create(
          :card => {
              :number => "4242424242424242",
              :exp_month => 3,
              :exp_year => 2020,
              :cvc => "314"
          },
      )
      customer = Stripe::Customer.create(
          card: token.id,
          description: "test",
          email: user.email
      )
      user.stripe_customer_id = customer.id
      user.save!
    end

    it "doesn't duplicate subscriptions", vcr: true do
      controller.request.stub(:referer).and_return("continuity-offer-1")
      post :purchase_continuity_offer
      Subscription.count.should eq 1
      post :purchase_continuity_offer
      Subscription.count.should eq 1
      #binding.pry
    end

  end

end
