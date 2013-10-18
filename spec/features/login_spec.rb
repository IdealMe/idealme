require 'spec_helper'

describe 'login page' do

  before :each do
    user = FactoryGirl.build(:user)
    user.save!
  end

  it 'testing login page', :js => true do
    visit new_user_session_path
    page.should have_content('Sign in to your Ideal Me account')
  end

  it 'testing login with valid data', :js => true do
    pending 'looks like a timing issue with active record'
    visit new_user_session_path
    fill_in 'user_email', :with => 'normal@idealme.com'
    fill_in 'user_password', :with => 'passpass'
    page.find('input[name="commit"]').click
    page.should_not have_content('Invalid email or password')
    page.should_not have_content('SIGN IN')
  end

  it 'testing login with invalid data', :js => true do
    visit new_user_session_path
    fill_in 'user_email', :with => 'normal@idealme.com'
    fill_in 'user_password', :with => 'charlie123123'
    page.find('input[name="commit"]').click
    page.should have_content('Invalid email or password')
  end

end
