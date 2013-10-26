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

    find('#top-take-this-course-link').click

    fill_in "Email", with: 'normal@idealme.com'
    fill_in "Password", with: 'passpass'
    find('#sign-in-button').click

    expect(current_path).to include '/orders'


    fill_in "Card number", with: '1234123412341234'
    fill_in "Security Code", with: '123'
    fill_in "Address line 1", with: '123 Main St.'
    fill_in "City", with: 'Nowheresville'
    fill_in "Zip", with: '11111'
    fill_in "State", with: 'CA'
    fill_in "Country", with: 'US'

    order_response = double(:success? => true)
    ActiveMerchant::Billing::StripeGateway.any_instance.stub(:purchase).and_return(order_response)
    Order.any_instance.stub(:valid?).and_return(true)

    click_button "Complete Purchase"

    expect(AffiliateSale.count).to eq 1
    expect(AffiliateClick.count).to eq 1
    expect(link.sales).to include AffiliateSale.first

  end

end
