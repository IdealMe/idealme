
require 'spec_helper'

describe 'affiliate links' do

  let!(:user)               { create(:user) }

  it "lets the user edit their account", js: true do
    visit root_path
    click_link "Sign in"
    fill_in "Email", with: user.email
    fill_in "Password", with: "passpass"
    click_button "Sign in"
    visit edit_user_registration_path
    screenshot
  end
end
