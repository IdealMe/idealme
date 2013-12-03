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

    #visit new_user_session_path
    #page.should have_content('Sign in to your Ideal Me account')

    #fill_in 'user_email', with: 'normal@idealme.com'
    #fill_in 'user_password', with: 'passpass'
    #page.find('input[name="commit"]').click
  end

  it 'allows customers to purchase courses', js: true do
    visit root_path
    screenshot
    click_link "Sample market"

    find('.top-enroll-btn').click


    find('.btn-complete-purchase').click
    page.should have_content('There was a problem validating your information')

    fill_in "Card Number", with: "4242424242424242"
    select "2017"
    fill_in "Security Code", with: "123"
    select "2017"
    select "01"
    
    fill_in "First Name", with: @user.firstname
    fill_in "Last Name", with: @user.lastname
    fill_in "Email", with: @user.email

    find('.btn-complete-purchase').click

    page.should have_content('Sign in to your')
    screenshot
    fill_in "Email", with: @user.email
    fill_in "Password", with: 'passpass'
    click_button "Sign in"
    
    screenshot
    fill_in "Card Number", with: "4242424242424242"
    select "2017"
    fill_in "Security Code", with: "123"
    select "2017"
    select "01"
    find('.btn-complete-purchase').click
    page.should have_content('Thank you, your order has been placed and you are enrolled in this course!')

    user = User.where(firstname: @user.firstname).last
    user.firstname.should eq @user.firstname
    user.courses.all.should include Course.last
    screenshot
  end

end
