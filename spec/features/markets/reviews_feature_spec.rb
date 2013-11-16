require 'spec_helper'

describe 'course preview page (market show)' do
  let!(:user)               { create(:user) }
  let!(:user2)              { create(:user2) }
  let!(:link)               { create(:affiliate_link) }
  let!(:affiliate_user)     { link.user }
  let!(:market)             { create(:market, course: course) }
  let!(:course)             { create(:course, owner: affiliate_user) }
  let!(:review)             { create(:review, owner: user, course: course) }
  let!(:bad_review)         { create(:bad_review, owner: user2, course: course) }

  it "has some tabs", js: true do
    visit market_path market
    click_link "2 reviews"
    sleep 1 # because there's an animated fade in on the tab content
    page.text.should_not include "hey there, come try this course!"
    page.text.should include "This course was awesome and now I can levitate"
    page.text.should include "this course sucked"
    screenshot
  end
end

