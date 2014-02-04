params = {"email"=>"charlie+22@idealme.com",
 "from"=>"charlie+22@idealme.com",
 "listname"=>"idealmeoptin",
 "meta_adtracking"=>"idealme.com",
 "meta_message"=>"1",
 "meta_required"=>"email",
 "meta_split_id"=>"",
 "meta_tooltip"=>"",
 "meta_web_form_id"=>"58003487",
 "name"=>"",
 "submit"=>"Submit",
 "action"=>"aweber_callback",
 "controller"=>"landings"}


require 'spec_helper'

describe 'sign up flow with workbook purchase', js: true, vcr: true do

  let!(:user)               { create(:user) }
  let!(:link)               { create(:affiliate_link) }
  let!(:affiliate_user)     { link.user }
  let!(:market)             { create(:market, course: course) }
  let!(:course)             { create(:course, owner: affiliate_user) }
  let!(:market2)            { create(:market2, course: course2) }
  let!(:course2)            { create(:course2, owner: affiliate_user) }
  let!(:goal)               { create(:goal) }

  it 'when user has account but is not signed in', js: true, vcr: true do

    visit '/getthebook'
    screenshot
    visit '/aweber_callback?email=charlie%2b22%40idealme%2ecom&from=charlie%2b22%40idealme%2ecom&listname=idealmeoptin&meta_adtracking=idealme%2ecom&meta_message=1&meta_required=email&meta_split_id=&meta_tooltip=&meta_web_form_id=58003487&name=&submit=Submit'
    page.current_path.should eq '/getthebook'
    screenshot

    find('#getthebook-btn').click
    page.current_path.should eq '/orders/new/workbook'
    screenshot
    fill_in "Card Number", with: '4242424242424242'
    screenshot
    fill_in "Security Code", with: '123'
    screenshot
    ActiveMerchant::Billing::CreditCard.any_instance.stub(:valid?).and_return(true)
    fill_in "First Name", with: "Bean"
    fill_in "Last Name", with: "Salad"
    fill_in "Email Address", with: user.email
    select "01", from: "Card exp month"
    select "2017", from: "Card exp year"
    select "Master Card", from: "Card type"
    screenshot
    click_button "Complete Purchase"
    screenshot
    page.current_path.should eq '/login'
    fill_in "Email", with: user.email
    fill_in "Password", with: "passpass"
    click_button "Sign in"
    screenshot
    page.current_path.should eq '/orders/new/workbook'
    click_button "Complete Purchase"
    screenshot
    Order.count.should eq 1
  end

  it 'send the user to the create account screen', js: true, vcr: true do
    visit '/getthebook'
    screenshot
    visit '/aweber_callback?email=charlie%2b22%40idealme%2ecom&from=charlie%2b22%40idealme%2ecom&listname=idealmeoptin&meta_adtracking=idealme%2ecom&meta_message=1&meta_required=email&meta_split_id=&meta_tooltip=&meta_web_form_id=58003487&name=&submit=Submit'
    page.current_path.should eq '/getthebook'
    screenshot

    find('#getthebook-btn').click
    page.current_path.should eq '/orders/new/workbook'
    screenshot


    fill_in "Card Number", with: '4242424242424242'
    screenshot
    fill_in "Security Code", with: '123'
    screenshot
    SendHipchatMessage.any_instance.stub(:send)
    ActiveMerchant::Billing::CreditCard.any_instance.stub(:valid?).and_return(true)

    fill_in "First Name", with: "Bean"
    fill_in "Last Name", with: "Salad"
    fill_in "Email Address", with: "beansalad@idealme.com"
    select "01", from: "Card exp month"
    select "2017", from: "Card exp year"
    select "Master Card", from: "Card type"
    screenshot
    click_button "Complete Purchase"

    screenshot
    page.current_path.should eq '/workbook-thanks'
    Order.count.should eq 1

  end

  it 'create account for user that skips workbook order', js: true, vcr: true do
    visit root_path
    screenshot
    visit '/aweber_callback?email=charlie%2b22%40idealme%2ecom&from=charlie%2b22%40idealme%2ecom&listname=idealmeoptin&meta_adtracking=idealme%2ecom&meta_message=1&meta_required=email&meta_split_id=&meta_tooltip=&meta_web_form_id=58003487&name=&submit=Submit'
    screenshot
    page.current_path.should eq '/getthebook'
    find('#skip-btn').click
    screenshot
    fill_in 'user_password', with: 'passpass'
    screenshot
    page.find('input[name="commit"]').click
    # goals page
    screenshot
    page.find('.btn-white').click
    screenshot
    page.current_path.should eq '/resources'
  end

  it 'declined card', js: true, vcr: true do
    visit '/getthebook'
    visit '/aweber_callback?email=charlie%2b22%40idealme%2ecom&from=charlie%2b22%40idealme%2ecom&listname=idealmeoptin&meta_adtracking=idealme%2ecom&meta_message=1&meta_required=email&meta_split_id=&meta_tooltip=&meta_web_form_id=58003487&name=&submit=Submit'
    page.current_path.should eq '/getthebook'

    find('#getthebook-btn').click
    page.current_path.should eq '/orders/new/workbook'
    screenshot
    fill_in "Card Number", with: '4000000000000002'
    fill_in "Security Code", with: '123'
    ActiveMerchant::Billing::CreditCard.any_instance.stub(:valid?).and_return(false)
    fill_in "First Name", with: "Bean"
    fill_in "Last Name", with: "Salad"
    fill_in "Email Address", with: 'leamsdaf@example.com'
    select "01", from: "Card exp month"
    select "2017", from: "Card exp year"
    select "Master Card", from: "Card type"
    screenshot
    click_button "Complete Purchase"
    fill_in "Card Number", with: '4242424242424242'
    screenshot
    click_button "Complete Purchase"
    screenshot
    page.text.should_not include "declined"
    Order.count.should eq 1
  end
end
