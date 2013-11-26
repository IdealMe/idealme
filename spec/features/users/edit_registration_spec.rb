
require 'spec_helper'

describe 'edit account settings' do

  let!(:user)               { create(:user) }

  it "lets the user edit their account" do
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

  it "lets the user edit the password" do
    visit root_path
    click_link "Sign in"
    fill_in "Email", with: user.email
    fill_in "Password", with: "passpass"
    click_button "Sign in"
    visit user_edit_password_path(user)
    screenshot

  end
end
