require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

describe 'market show page' do
  let!(:user)               { create(:user) }
  let!(:link)               { create(:affiliate_link) }
  let!(:affiliate_user)     { link.user }
  let!(:market)             { create(:market, course: course) }
  let!(:course)             { create(:course, owner: affiliate_user) }
  let!(:section)            { create(:section, course_id: course.id) }
  let!(:lecture)            { create(:lecture, section_id: section.id) }

  before :each do
    Warden.test_reset!
  end

  it "show a syllabus on the market page", js: true, vcr: true do
    visit course_path course
    click_link "Syllabus"
    sleep 1
    screenshot
    page.text.should include section.name
    page.text.should include lecture.name
  end
end

