require 'spec_helper'

describe 'ordering' do
  let!(:link)               { create(:affiliate_link) }
  let!(:affiliate_user)     { link.user }
  let!(:market)             { create(:market, course: course) }
  let!(:course)             { create(:course, owner: affiliate_user) }

  before :each do
  end

  it "enroll in course without a user account", vcr: true, js: true do
    User.count.should eq 1
    visit market_path market
    find('.top-enroll-btn').click
    current_path.should eq '/orders/new/sample-market'

    fill_in "Card Number", with: '1234123412341234'
    fill_in "Security Code", with: '123'
    order_response = double(:success? => true)
    ActiveMerchant::Billing::StripeGateway.any_instance.stub(:purchase).and_return(order_response)
    ActiveMerchant::Billing::CreditCard.any_instance.stub(:valid?).and_return(true)
    #Order.any_instance.stub(:valid?).and_return(true)
    click_button "Complete Purchase"
    page.text.should include "First Name can't be blank"
    page.text.should include "Last Name can't be blank"
    page.text.should include "Email Address can't be blank"

    fill_in "First Name", with: "Bean"
    fill_in "Last Name", with: "Salad"
    fill_in "Email Address", with: "beansalad@idealme.com"
    select "01", from: "Card exp month"
    select "2017", from: "Card exp year"
    select "Master Card", from: "Card type"

    click_button "Complete Purchase"

    Order.count.should eq 1

    User.count.should eq 2
    emails.count.should eq 1
    confirm_link = URI.extract(emails.last.body.to_s, :http).first

    uri = URI.parse(confirm_link)
    visit "#{uri.path}?#{uri.query}"
    screenshot

    fill_in "Password", with: "123123123"
    fill_in "Confirmation", with: "123123123"
    click_button "Activate"
    screenshot
  end

  it "handles a card declined", vcr: true, js: true do
    User.count.should eq 1
    visit market_path market
    find('.top-enroll-btn').click
    current_path.should eq '/orders/new/sample-market'

    screenshot
    fill_in "Card Number", with: '4000000000000002'
    fill_in "Security Code", with: '123'
    #order_response = double(:success? => true)
    #ActiveMerchant::Billing::StripeGateway.any_instance.stub(:purchase).and_return(order_response)
    ActiveMerchant::Billing::CreditCard.any_instance.stub(:valid?).and_return(true)
    #Order.any_instance.stub(:valid?).and_return(true)

    fill_in "First Name", with: "Bean"
    fill_in "Last Name", with: "Salad"
    fill_in "Email Address", with: "beansalad@idealme.com"
    select "01", from: "Card exp month"
    select "2017", from: "Card exp year"
    select "Master Card", from: "Card type"

    click_button "Complete Purchase"
    screenshot

    page.text.should include "Your card was declined"
    Order.count.should eq 0


  end
end

