require 'spec_helper'

describe 'affiliate links', ci_only: true do

  let!(:user)               { create(:user) }
  let!(:link)               { create(:affiliate_link) }
  let!(:affiliate_user)     { link.user }
  let!(:market)             { create(:market, course: course) }
  let!(:course)             { create(:course, owner: affiliate_user) }
  let!(:market2)            { create(:market2, course: course2) }
  let!(:course2)            { create(:course2, owner: affiliate_user) }

  it 'credits affiliates with sales', js: true, vcr: true do
    visit '/now/my-link'

    expect(current_path).to eq '/markets/sample-market'
    expect(page.text).to include 'affiliate_phil_9000'

    find('.enroll-btn').click

    expect(current_path).to include '/orders'
    submit_order_form
    expect(AffiliateSale.count).to eq 1
    expect(AffiliateClick.count).to eq 1
    expect(link.sales).to include AffiliateSale.first
  end

  it 'can link to other markets with a :market_tag', js: true, vcr: true do
    visit '/now/my-link/at-other-market-tag'

    expect(current_path).to eq '/markets/another-market'
    expect(page.text).to include 'affiliate_phil_9000'

    find('.enroll-btn').click

    expect(current_path).to eq '/orders/new/another-market'

    submit_order_form

    expect(AffiliateSale.count).to eq 1
    expect(AffiliateClick.count).to eq 1
    expect(link.sales).to include AffiliateSale.first
  end

  it 'credits affiliates with sales', js: true, vcr: true do
    visit '/markets/at-market-tag/phil.deal'
    affiliate_user.username.should eq 'affiliate_phil_9000'
    expect(current_path).to eq '/markets/sample-market'
    expect(page.text).to include 'affiliate_phil_9000'

    find('.enroll-btn').click

    expect(current_path).to include '/orders'

    submit_order_form

    expect(AffiliateSale.count).to eq 1
    expect(AffiliateClick.count).to eq 1
    expect(link.sales).to_not include AffiliateSale.first
  end

end
