require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

describe 'roger love course purchase' do

  let!(:course) { create(:course, roger_love: true, owner: admin) }
  let!(:market) { create(:market, course: course) }
  let!(:user)   { create(:user) }
  let!(:admin)   { create(:user_admin) }

  before :each do
    Warden.test_reset!
    login_as user, scope: :user
  end

  it 'testing roger love course purchase', js: true, vcr: true, ci_only: true do
    visit root_path
    click_link "MARKETPLACE"
    screenshot
    click_link "Sample market"

    find('.top-enroll-btn').click

    fill_in "Card Number", with: "4242424242424242"
    fill_in "Security Code", with: "123"

    fill_in "First Name", with: user.firstname
    fill_in "Last Name", with: user.lastname
    fill_in "Email", with: user.email
    fill_in "Card exp month", with: "01"
    fill_in "Card exp year", with: "2020"
    click_button "Complete Purchase"

    Timeout.timeout(10.seconds) do
      loop until page.text.include?('Thank you, your order has been placed and you are enrolled in this course!')
    end

    user.courses.load.to_a.should include Course.last
    click_link "GO TO COURSE"
    screenshot
    email = last_email
  end

end
