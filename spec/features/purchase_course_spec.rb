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

    click_link "Add courses"

    within('.container.courses') do
      click_link "Sample market"
    end
    find('#top-take-this-course-link').click

  end

  it 'allows customers to purchase courses', js: true do

    firstname_value = find("#order_card_firstname").value
    expect(firstname_value).to eq @user.firstname

  end

end
