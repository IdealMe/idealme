require 'spec_helper'

describe 'Users' do
  describe 'Authentication' do
    it 'should allow the user to login' do
      
      user = create(:user)
      
      visit new_user_session_path

      fill_in 'Email', :with => 'normal_idealme@idealme.com'
      fill_in 'Password', :with => 'passpass'

      click_button 'Sign in'
    end
  end
end

