require 'spec_helper'

describe 'registration' do

  let!(:goal)               { create(:goal) }

  it 'testing registration', js: true do
    visit new_user_registration_path
    page.should have_content('Create your FREE Ideal Me account')
    fill_in 'user_email', with: 'newguy1000@idealme.com'
    fill_in 'user_password', with: 'passpas'
    page.find('input[name="commit"]').click
    page.should have_content('too short')
    fill_in 'user_email', with: 'newguy1000@idealme.com'
    fill_in 'user_password', with: 'passpass'
    page.find('input[name="commit"]').click
    expect(current_path).to eq '/user/welcome'
  end

end
