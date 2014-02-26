require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

describe 'affiliate dashboard functionality', ci_only: true do

  let!(:user)               { create(:user) }
  let!(:user2)              { create(:user2) }
  let!(:user3)              { create(:user3) }
  let!(:link)               { create(:affiliate_link) }
  let!(:affiliate_user)     { link.user }
  let!(:market)             { create(:market, course: course) }
  let!(:course)             { create(:course, owner: affiliate_user) }
  let!(:market2)            { create(:market2, course: course2) }
  let!(:course2)            { create(:course2, owner: affiliate_user) }

  before :each do
    Warden.test_reset!
    buy_course_as user
    expect(Order.count).to eq 1
  end

  it "shows affiliate dashboard index", js: true, vcr: true do
    login_as(affiliate_user, scope: :user, run_callbacks: false)
    visit "/dashboard"
    expect(page.text).to include 'Total units sold: 1'
    expect(page.text).to include 'Total affiliates pay out: $498.5000'
    expect(AffiliateSale.count).to eq 1
    expect(AffiliateClick.count).to eq 1
    AffiliateSale.first.user_id.should eq affiliate_user.id
  end

  it "calculates conversions", js: true, vcr: true do
    click = AffiliateClick.last.dup
    click.save!
    Capybara.reset_session!
    login_as(affiliate_user, scope: :user, run_callbacks: false)
    visit "/dashboard"
    expect(page.text).to include 'Conversion: 50'
    expect(page.text).to include 'Total affiliates pay out: $498.5000'
  end

  it 'allows affiliates to setup tracking links', js: true, vcr: true do
    login_as(affiliate_user, scope: :user, run_callbacks: false)
    visit "/dashboard/affiliates?tab=links"
    click_link "New Tracking Link"
    fill_in "Slug", with: "link-one"
    select "Sample market", from: "Market tag"
    fill_in "Note", with: "tracking link note"
    click_button 'Create'

    link = AffiliateLink.last
    link.slug.should eq 'link-one'

    logout(:user)

    visit "/now/#{link.slug}"
    find('.enroll-btn').click
    link.affiliate_clicks.count.should eq 1
    buy_course_as(user2, link.slug)
    link.sales.count.should eq 1

    logout(:user)

    buy_course_as(user3, link.slug, 'at-other-market-tag')
    logout(:user)
    login_as(affiliate_user, scope: :user, run_callbacks: false)
    visit "/dashboard/affiliates"
    click_link "Tracking Links"
    click_link "link-one"
    # visit "/dashboard/affiliates/#{link.slug}"
    expect(page.text).to include 'Total units sold: 2'
    expect(page.text).to include 'Total unique users signed up: 2'
  end

  it 'total sales', js: true, vcr: true do
    buy_course_as user2
    buy_course_as user3
    login_as(affiliate_user, scope: :user, run_callbacks: false)
    visit "/dashboard/affiliates?tab=sale"
    expect(page.text).to include 'normal idealme'
  end

  it 'affiliate urls', js: true, vcr: true do
    pending "no assertions"
    login_as(affiliate_user, scope: :user, run_callbacks: false)
    visit "/dashboard/affiliates?tab=urls"
  end

end
