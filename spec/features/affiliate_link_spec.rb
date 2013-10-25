require 'spec_helper'

describe 'affiliate links' do

  before :each do

  end


  let!(:user)           { create(:user) }
  let!(:link)           { create(:affiliate_link) }
  let!(:affiliate_user) { link.user }
  let!(:market)         { create(:market, course: course) }
  let!(:course)         { create(:course, owner: affiliate_user) }



  it 'credits affiliates with sales', js: true do
    visit '/now/my-link'
    expect(current_path).to eq '/markets/sample-market'
    expect(page.text).to include 'affiliate_phil_9000'

    find('#top-take-this-course-link').click

    fill_in "Email", with: 'normal@idealme.com'
    fill_in "Password", with: 'passpass'
    find('#sign-in-button').click
    expect(current_path).to eq '/orders'
  end

end
