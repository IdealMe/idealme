require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

describe 'course preview page (market show)' do
  let!(:user)               { create(:user) }
  let!(:user2)              { create(:user2) }
  let!(:link)               { create(:affiliate_link) }
  let!(:affiliate_user)     { link.user }
  let!(:market)             { create(:market, course: course) }
  let!(:course)             { create(:course, owner: affiliate_user) }
  let!(:review)             { create(:review, owner: user, course: course) }
  let!(:bad_review)         { create(:bad_review, owner: user2, course: course) }

  before :each do
    Warden.test_reset!
    buy_course_as user
  end

  it "has some tabs, including a reviews tab", js: true do
    visit market_path market
    click_link "2 reviews"
    sleep 1 # because there's an animated fade in on the tab content
    page.text.should_not include "hey there, come try this course!"
    page.text.should include "This course was awesome and now I can levitate"
    page.text.should include "this course sucked"
    screenshot
  end

  it "allows a course customer to add a review", js: true do
    # subscribe user to course
    user.subscribe_course(market.course)
    login_as(user, scope: :user, run_callbacks: false)

    visit course_path course
    screenshot

    page.text.should include "Rate this course:"
    page.text.should_not include "Please tell others what you think of this course"
    find('.icon-thumbs-up').click
    page.text.should include "Please tell others what you think of this course"

    fill_in "review_title", with: "I liked it"
    fill_in "review_content", with: "One of my kids decided to hide a plastic fork in our old toaster and we didn't realized until our senses were awaken by the smell of burning plastic. Our search for an inexpensive efficient toaster landed us here. This toaster works great. Any reviews that suggest that the heating shield interferes somehow with the toasters operation either has a faulty machine or there problems are a result of user error. This is a great value for the price. I eat Ezekiel bread which is highly perishable bread that keeps well in the freezer. Toast comes out perfectly, as do bagels and thicker breads. Darkness settings 1 - 5 are very accurate. Glad I went with this one. It is a very handsome appliance as well. P.S. I don't usually write reviews but I felt compelled. Get this toaster you won't be disappointed."
    click_button "Add Review"
    screenshot
    Review.count.should eq 3

    visit market_path course.default_market
    click_link "3 reviews"
    sleep 1
    screenshot
    Vote.count.should eq 1
    market.course.up_votes.should eq 1
  end

end

