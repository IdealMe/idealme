require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

describe 'idealme gems', :vcr do
  let!(:user)               { create(:user) }
  let!(:goal)               { create(:goal) }
  let!(:jewel)               { create(:jewel, linked_goal: goal) }

  before :each do
    Warden.test_reset!
    login_as user, scope: :user
  end

  it "goals have related gems", js: true, vcr: true do
    jewel.fetch!
    jewel.update_attribute :visible, true
    visit goal_path(goal)
    status_code.should_not eq 500
    expect(page.text).to include 'The Wind Waker'
  end

  it 'lets users create new gems', js: true, vcr: true do
    visit goal_path(goal)
    find('.btn-new-gem').click
    sleep 2
    status_code.should_not eq 500
    expect(page.text).to include 'You can add any web page, article, image, video, Tweet or Facebook post that has heped you with the weight loss goal'

    input = find('.add-gem-url-input')
    input.set('http://shop.lululemon.com/products/clothes-accessories/pants-yoga/Wunder-Under-Pant-Reversible-31552?cc=12457&skuId=3528843&catId=pants-yoga')
    find('.btn-post-gem').click
    sleep 2
    expect(page.text).to include "This is a"

    find('#gem-comment').set('This page is the greatest')
    find('.btn-edit-gem').click
    sleep 2
    expect(page.text).to include 'wunder'

    find('.gem-card > .view-gem-link').click
    sleep 2
    screenshot
    expect(page.text).to include 'This page is the greatest'

  end

  it 'has comments that can be voted on', js: true, vcr: true do
    jewel.fetch!
    jewel.comments.create(owner: user, content: "That’s exactly what we’d like to know. Tapmates has spent the past four years providing its clients with innovative and award-winning apps such as Wood Camera, Piictu, Klip, and Summly, and now we’re looking for our next big challenge. If you have an interesting project, want to discuss a big idea, or need some extra expertise, we can put our experience and skills to work for you.")
    jewel.update_attribute :visible, true

    visit goal_path(goal)

    find('.gem-card > .view-gem-link').click
    sleep 2
    screenshot
    page.should have_css('.comment-content .vote-controls')
    find('.comment-content .like').click
    expect(jewel.comments.last.up_votes).to eq 1
    find('.comment-content .dislike').click
    expect(jewel.comments.last.up_votes).to eq 0
    expect(jewel.comments.last.down_votes).to eq 1
  end

end

