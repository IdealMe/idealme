require 'spec_helper'

describe 'affiliate links' do

  let!(:user)               { create(:user) }
  let!(:link)               { create(:affiliate_link, tracking_tag: 'tracker-9000') }
  let!(:affiliate_user)     { link.user }
  let!(:market)             { create(:market, course: course) }
  let!(:course)             { create(:course, owner: affiliate_user) }

  it 'credits affiliates with sales', js: true do
    visit '/now/my-link'

    expect(current_path).to eq '/markets/sample-market'
    expect(page.text).to include 'affiliate_phil_9000'

    find('.enroll-btn').click

    fill_in "Email", with: 'normal@idealme.com'
    fill_in "Password", with: 'passpass'
    find('#sign-in-button').click

    expect(current_path).to include '/orders'


    fill_in "Card Number", with: '1234123412341234'
    fill_in "Security Code", with: '123'


    order_response = double(:success? => true)
    ActiveMerchant::Billing::StripeGateway.any_instance.stub(:purchase).and_return(order_response)
    Order.any_instance.stub(:valid?).and_return(true)

    click_button "Complete Purchase"

    expect(AffiliateSale.count).to eq 1
    expect(AffiliateClick.count).to eq 1
    expect(link.sales).to include AffiliateSale.first
  end

  it 'credits affiliates with sales', js: true do
    visit '/markets/market_tag/phil.deal'
    affiliate_user.username.should eq 'affiliate_phil_9000'
    expect(current_path).to eq '/markets/sample-market'
    expect(page.text).to include 'affiliate_phil_9000'

    find('.enroll-btn').click

    fill_in "Email", with: 'normal@idealme.com'
    fill_in "Password", with: 'passpass'
    find('#sign-in-button').click

    expect(current_path).to include '/orders'


    fill_in "Card Number", with: '1234123412341234'
    fill_in "Security Code", with: '123'


    order_response = double(:success? => true)
    ActiveMerchant::Billing::StripeGateway.any_instance.stub(:purchase).and_return(order_response)
    Order.any_instance.stub(:valid?).and_return(true)

    click_button "Complete Purchase"

    expect(AffiliateSale.count).to eq 1
    expect(AffiliateClick.count).to eq 1
    expect(link.sales).to_not include AffiliateSale.first
  end

end
