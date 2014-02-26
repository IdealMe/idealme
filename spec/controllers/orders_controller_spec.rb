require 'spec_helper'

describe OrdersController do

  let!(:link)               { create(:affiliate_link) }
  let!(:affiliate_user)     { link.user }
  let!(:market)             { create(:market, course: course) }
  let!(:course)             { create(:course, owner: affiliate_user) }
  let!(:market2)            { create(:market2, course: course2) }
  let!(:course2)            { create(:course2, owner: affiliate_user) }
  let!(:goal)               { create(:goal) }
  describe "POST create_subscription_order" do
    let(:create_params) {
      {
        "utf8" => "✓",
        "order" => {
          "market_id" => "",
          "course_id" => "",
          "user_id" => "",
          "time" => "1391831478",
          "checksum" => "234b344f50a34e42c6c0f5b71127b9d00317a49f",
          "card_firstname" => "Bean",
          "card_lastname" => "Salad",
          "card_email" => "beansalad@idealme.com",
          "billing_address1" => "",
          "billing_address2" => "",
          "billing_city" => "",
          "billing_zip" => "",
          "billing_state" => "",
          "billing_country" => "US"
        },
        "stripeToken" => @token,
        "controller" => "orders",
        "action" => "create_subscription_order"
      }
    }

    before :each do
      @token = create_token_for(card_number)
    end

    describe "Good card" do
      let(:card_number) { "4242424242424242" }
      it 'creates the sub', vcr: true do
        post :create_subscription_order, create_params
        user = User.where(email: "beansalad@idealme.com").first
        expect(user.stripe_token).to eq create_params["stripeToken"]
        expect(Order.count).to eq 1
        expect(Subscription.count).to eq 1

        # json in postgres! http://clarkdave.net/2013/06/what-can-you-do-with-postgresql-and-json/
        stripe_id = Subscription.select("stripe_object->>'id' AS stripe_id").first.stripe_id
        expect(Subscription.last.stripe_object.to_s).to include stripe_id
      end
    end
  end
  describe "POST create_workbook_order" do
    let(:create_params) {
      {
        "utf8" => "✓",
        "order" => {
          "market_id" => "",
          "course_id" => "",
          "user_id" => "",
          "time" => "1391831478",
          "checksum" => "234b344f50a34e42c6c0f5b71127b9d00317a49f",
          "card_firstname" => "Bean",
          "card_lastname" => "Salad",
          "card_email" => "beansalad@idealme.com",
          "billing_address1" => "",
          "billing_address2" => "",
          "billing_city" => "",
          "billing_zip" => "",
          "billing_state" => "",
          "billing_country" => "US"
        },
        "stripeToken" => @token,
        "controller" => "orders",
        "action" => "create_workbook_order"
      }
    }

    before :each do
      @token = create_token_for(card_number)
    end

    describe "Good card" do
      let(:card_number) { "4242424242424242" }
      it 'takes the stripe token', vcr: true do
        post :create_workbook_order, create_params
        user = User.where(email: "beansalad@idealme.com").first
        expect(user.stripe_token).to eq create_params["stripeToken"]
        expect(Order.count).to eq 1
      end
    end

    describe "Bad card" do
      let(:card_number) { "4000000000000002" }
      it 'takes the stripe token', vcr: true do
        post :create_workbook_order, create_params
        user = User.where(email: "beansalad@idealme.com").first
        expect(user.stripe_token).to eq create_params["stripeToken"]
        expect(Order.count).to eq 0
      end
    end

  end

  def create_token_for(card_number)
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    token = Stripe::Token.create(
      :card => {
        :number => card_number,
        :exp_month => 2,
        :exp_year => 2015,
        :cvc => "314"
      },
    )
    token.id
  end
end
