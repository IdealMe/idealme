
require 'spec_helper'

describe 'hidden markets' do
  let!(:user)               { create(:user) }
  let!(:link)               { create(:affiliate_link) }
  let!(:affiliate_user)     { link.user }
  let!(:market)             { create(:market, course: course) }
  let!(:course)             { create(:course, owner: affiliate_user) }

  it "allows hidden markets", js: true do
    course.hidden = true
    course.save!
    visit markets_path
    screenshot
    page.text.should_not include 'Sample market'
  end

end

