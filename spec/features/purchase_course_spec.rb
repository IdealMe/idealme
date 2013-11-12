require 'spec_helper'

describe 'purchase course' do

  before :each do
    @user = FactoryGirl.build(:user)
    @user.save!

    admin = FactoryGirl.build(:user_admin)
    admin.instructor_about = "About Admin"
    admin.save!

    market = FactoryGirl.build(:market)
    market.save!

    course = FactoryGirl.build(:course, default_market_id: market.id)
    course.owner = admin
    course.save!

    market.course = course
    market.save!

    visit new_user_session_path
    page.should have_content('Sign in to your Ideal Me account')

    fill_in 'user_email', with: 'normal@idealme.com'
    fill_in 'user_password', with: 'passpass'
    page.find('input[name="commit"]').click
  end

  it 'allows customers to purchase courses', js: true do
    click_link "Add courses"

    within('.container.courses') do
      click_link "Sample market"
    end

    find('.top-enroll-btn').click

    page.should_not have_content('Sign in to your Ideal Me account')
    firstname_value = find("#order_card_firstname").value
    expect(firstname_value).to eq @user.firstname

    find('.btn-complete-purchase').click
    screenshot
    page.should have_content('There was a problem validating your information')

    fill_in "Card number", with: "4242424242424242"
    select "2017"
    fill_in "Security Code", with: "123"
    find('.btn-complete-purchase').click

    page.should have_content('Thank you, your order has been placed and you are enrolled in this course!')

  end

end
