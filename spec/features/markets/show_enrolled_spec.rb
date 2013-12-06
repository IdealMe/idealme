
require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

describe 'market page shows number of enrolled users' do
  let!(:user)               { create(:user) }
  let!(:user2)              { create(:user2) }
  let!(:link)               { create(:affiliate_link) }
  let!(:affiliate_user)     { link.user }
  let!(:market)             { create(:market, course: course) }
  let!(:course)             { create(:course, owner: affiliate_user) }

  before :each do
    Warden.test_reset!
  end

  it "show the number of enrolled users", js: true, vcr: true do
    visit market_path market
    page.text.should include '0 enrolled'
    buy_course_as user
    buy_course_as user2
    visit market_path market
    screenshot
    page.text.should include '2 enrolled'
  end
end

