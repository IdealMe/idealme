

require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

describe 'course show page' do
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

  it "show a syllabus on the course page", js: true do
    buy_course_as user
    login_as user, scope: :user
    visit course_path course
    sleep 1
    screenshot
    page.text.downcase.should include section.name.downcase
    page.text.should include lecture.name
  end
end

