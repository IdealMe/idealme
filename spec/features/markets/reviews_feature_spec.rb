require 'spec_helper'

describe 'course preview page (market show)' do
  let!(:user)               { create(:user) }
  let!(:link)               { create(:affiliate_link) }
  let!(:affiliate_user)     { link.user }
  let!(:market)             { create(:market, course: course) }
  let!(:course)             { create(:course, owner: affiliate_user) }
  let!(:market2)            { create(:market2, course: course2) }
  let!(:course2)            { create(:course2, owner: affiliate_user) }

  it "has some tabs", js: true do
    visit market_path market
    screenshot
    click_link "Reviews"
    page.text.should include "This thing is awesome"
  end
end

