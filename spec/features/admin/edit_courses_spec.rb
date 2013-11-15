require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

describe 'editing courses' do

  let!(:user)               { create(:user) }
  let!(:admin)              { create(:user_admin) }
  let!(:link)               { create(:affiliate_link) }
  let!(:affiliate_user)     { link.user }
  let!(:market)             { create(:market, course: course) }
  let!(:course)             { create(:course, owner: affiliate_user) }

  before :each do
    login_as(admin, scope: :user)
  end

  it 'editing a market from courses', js: true do
    visit '/admin/courses'
    click_link "Sample course"
    expect(find("#course_affiliate_commission").value).to eq '50.000'

    click_link "Previews"
    fill_in "Name", with: "New fancy market name"

    click_button "Save"
    find("#previews-tab.active")
    expect(find("#course_default_market_attributes_name").value).to eq 'New fancy market name'
    click_link "Sections"
    # let's make a new section
    click_link "New Section"
    fill_in "Name", with: "beans"
    click_button "Save"
    find("#course-content-tab.active")

  end

end
