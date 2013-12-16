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

  it 'lets users create new gems', js: true, vcr: true do
    login_as user, scope: :user
    visit goal_gems_path(goal)
    find('.btn-new-gem').click
    screenshot
    status_code.should_not eq 500

    expect(page.text).to include 'You can add any web page, article, image, video, Tweet or Facebook post that has heped you with the weight loss goal'
    input = find('.add-gem-url-input')
    input.set('http://shop.lululemon.com/products/clothes-accessories/pants-yoga/Wunder-Under-Pant-Reversible-31552?cc=12457&skuId=3528843&catId=pants-yoga')
    find('.btn-post-gem').click
    sleep 2
    screenshot
    expect(page.text).to include "This is a"
  end

end

