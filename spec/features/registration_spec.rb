require 'spec_helper'

describe 'registration' do

  it 'testing login page', js: true do
    visit new_user_registration_path
    page.should have_content('Create your FREE Ideal Me account')
    #fill_in 'user_username', with: 'newguy'
    fill_in 'user_email', with: 'newguy1000@idealme.com'
    fill_in 'user_password', with: 'passpass'
    page.find('input[name="commit"]').click
    expect(current_path).to eq '/newguy1000/welcome'
  end

end
