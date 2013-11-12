require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

def buy_course_as(user)
  login_as(user, scope: :user)
  visit '/now/my-link'
  find('.enroll-btn').click
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
end

describe 'affiliate dashboard functionality' do

  let!(:user)               { create(:user) }
  let!(:link)               { create(:affiliate_link, tracking_tag: 'tracker-9000') }
  let!(:affiliate_user)     { link.user }
  let!(:market)             { create(:market, course: course) }
  let!(:course)             { create(:course, owner: affiliate_user) }

  before :each do
    buy_course_as user
  end

  it "shows affiliate dashboard index", js: true do
    login_as(affiliate_user, scope: :user)
    visit "/dashboard"
    expect(page.text).to include 'Total units sold: 1'
    expect(page.text).to include 'Total affiliates pay out: $498.5000'
  end

  it "calculates conversions", js: true do
    Capybara.reset_session!
    visit '/now/my-link'
    find('.enroll-btn').click
    Capybara.reset_session!
    login_as(affiliate_user, scope: :user)
    visit "/dashboard"
    expect(page.text).to include 'Conversion: 50'
    expect(page.text).to include 'Total affiliates pay out: $498.5000'
  end

  it 'links', js: true do
    login_as(affiliate_user, scope: :user)
    visit "/dashboard/affiliates?tab=links"
    # screenshot
  end

  it 'total sales', js: true do
    user2 = create(:user2)
    user3 = create(:user3)
    buy_course_as user2
    buy_course_as user3
    login_as(affiliate_user, scope: :user)
    visit "/dashboard/affiliates?tab=sale"
    expect(page.text).to include 'normal idealme'
  end

  it 'affiliate urls', js: true do
    login_as(affiliate_user, scope: :user)
    visit "/dashboard/affiliates?tab=urls"
    # screenshot
  end

end
