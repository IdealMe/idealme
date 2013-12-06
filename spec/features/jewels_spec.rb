require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

describe 'idealme gems', :vcr do
  let!(:user)               { create(:user) }
  let!(:goal)               { create(:goal) }
  let!(:jewel)               { create(:jewel, linked_goal: goal) }

  before :each do
    Warden.test_reset!
  end

  it "goals have related gems", js: true, vcr: true do
    jewel.fetch!
    login_as user, scope: :user
    visit goal_gems_path(goal)
    status_code.should_not eq 500
    expect(page.text).to include 'The Wind Waker - Hey Ash Whatcha Playin'
  end

  it 'lets users create new gems' do

    login_as user, scope: :user
    visit goal_gems_path(goal)
    find('.btn-new-gem').click

    expect(page.text).to include 'You can add any web page, article, image, video, Tweet or Facebook post that has heped you with the weight loss goal'
  end

end

