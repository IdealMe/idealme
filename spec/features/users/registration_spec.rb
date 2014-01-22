
require 'spec_helper'

describe 'edit account settings' do

  let!(:user)               { create(:user) }

  it "lets the user edit their account", vcr: true do
    visit root_path
    click_link "Sign in"
    fill_in "Email", with: user.email
    fill_in "Password", with: "passpass"
    click_button "Sign in"
    visit edit_user_registration_path
    fill_in "First name", with: "beansie"
    click_button "Save"
    user.reload.firstname.should eq "beansie"
  end

  it "lets the user edit the password", js: true, vcr: true do
    visit root_path
    click_link "Sign in"
    fill_in "Email", with: user.email
    fill_in "Password", with: "passpass"
    click_button "Sign in"
    visit user_edit_password_path(user)
    fill_in "New password", with: "123123123"
    fill_in "Password confirmation", with: "12312312"
    click_button "Save"
    page.text.should include "match"
    fill_in "New password", with: "123123123"
    fill_in "Password confirmation", with: "123123123"
    click_button "Save"
    page.text.should_not include "match"
    visit destroy_user_session_path
    visit root_path
    click_link "Sign in"
    fill_in "Email", with: user.email
    fill_in "Password", with: "passpass"
    click_button "Sign in"
    page.text.should include "Invalid email"
    fill_in "Email", with: user.email
    fill_in "Password", with: "123123123"
    click_button "Sign in"
    page.text.should_not include "Invalid email"
  end
end

describe 'new registration' do
  let!(:goal)   { create(:goal) }
  let!(:market) { create(:market) }
  let!(:course) { create(:course, default_market_id: market.id) }

  it 'shows a special flash message for new users', js: true, vcr: true do
    pending "May not be needed with new aweber flow"
    visit root_path
    click_link "Sign up"
    fill_in "Email", with: 'newuser@idealme.com'
    fill_in "Password", with: "passpass"
    find('.btn-sign-up').click
    screenshot
    # expect(page.text).to include 'Hi! Now what? On this page you can keep track of your goals.'
  end
end

















