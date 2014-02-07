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
    visit '/aweber_callback?email=charlie%2b22%40idealme%2ecom&from=charlie%2b22%40idealme%2ecom&listname=idealmeoptin&meta_adtracking=idealme%2ecom&meta_message=1&meta_required=email&meta_split_id=&meta_tooltip=&meta_web_form_id=58003487&name=&submit=Submit'
    page.current_path.should eq '/getthebook'
    find('#getthebook-btn').click
    page.current_path.should eq '/orders/new/workbook'
    fill_in "Card Number", with: '4242424242424242'
    fill_in "Security Code", with: '123'
    ActiveMerchant::Billing::CreditCard.any_instance.stub(:valid?).and_return(true)
    fill_in "First Name", with: "Bean"
    fill_in "Last Name", with: "Salad"
    fill_in "Email Address", with: user.email
    select "01", from: "Card exp month"
    select "2017", from: "Card exp year"
    select "Master Card", from: "Card type"
    click_button "Complete Purchase"
    page.current_path.should eq '/login'
    fill_in "Email", with: user.email
    fill_in "Password", with: "passpass"
    click_button "Sign in"
    page.current_path.should eq '/orders/new/workbook'
    click_button "Complete Purchase"
    Order.count.should eq 1
  end

  it 'send the user to the create account screen', js: true, vcr: true do
    visit '/getthebook'
    visit '/aweber_callback?email=charlie%2b22%40idealme%2ecom&from=charlie%2b22%40idealme%2ecom&listname=idealmeoptin&meta_adtracking=idealme%2ecom&meta_message=1&meta_required=email&meta_split_id=&meta_tooltip=&meta_web_form_id=58003487&name=&submit=Submit'
    page.current_path.should eq '/getthebook'
    find('#getthebook-btn').click
    page.current_path.should eq '/orders/new/workbook'
    fill_in "Card Number", with: '4242424242424242'
    fill_in "Security Code", with: '123'
    SendHipchatMessage.any_instance.stub(:send)
    ActiveMerchant::Billing::CreditCard.any_instance.stub(:valid?).and_return(true)

    fill_in "First Name", with: "Bean"
    fill_in "Last Name", with: "Salad"
    fill_in "Email Address", with: "beansalad@idealme.com"
    select "01", from: "Card exp month"
    select "2017", from: "Card exp year"
    select "Master Card", from: "Card type"
    click_button "Complete Purchase"

    page.current_path.should eq '/workbook-thanks'
    Order.count.should eq 1

    user = User.where(email: "beansalad@idealme.com").last
    Order.last.user.should eq user

    # open email, get link, go to confirm
    email = last_email
    User.count.should eq 3
    emails.count.should eq 2
    confirm_link = URI.extract(emails.first.body.to_s, :http).first
    uri = URI.parse(confirm_link)
    visit "#{uri.path}?#{uri.query}"
    fill_in "Password", with: "123123123"
    fill_in "Confirmation", with: "12312312"
    click_button "Activate"
    expect(current_path).to eq '/users/confirmation'

    fill_in "Password", with: "123123123"
    fill_in "Confirmation", with: "123123123"
    click_button "Activate"
    expect(current_path).to eq user_path(user)
  end

  it 'create account for user that skips workbook order', js: true, vcr: true do
    visit root_path
    visit '/aweber_callback?email=charlie%2b22%40idealme%2ecom&from=charlie%2b22%40idealme%2ecom&listname=idealmeoptin&meta_adtracking=idealme%2ecom&meta_message=1&meta_required=email&meta_split_id=&meta_tooltip=&meta_web_form_id=58003487&name=&submit=Submit'
    page.current_path.should eq '/getthebook'
    find('#skip-btn').click
    fill_in 'user_password', with: 'passpass'
    page.find('input[name="commit"]').click
    # goals page
    page.find('.btn-white').click
    page.current_path.should eq '/resources'
  end

  it 'declined card', js: true, vcr: true do
    visit '/getthebook'
    visit '/aweber_callback?email=charlie%2b22%40idealme%2ecom&from=charlie%2b22%40idealme%2ecom&listname=idealmeoptin&meta_adtracking=idealme%2ecom&meta_message=1&meta_required=email&meta_split_id=&meta_tooltip=&meta_web_form_id=58003487&name=&submit=Submit'
    page.current_path.should eq '/getthebook'

    find('#getthebook-btn').click
    page.current_path.should eq '/orders/new/workbook'
    fill_in "Card Number", with: '4000000000000002'
    fill_in "Security Code", with: '123'
    ActiveMerchant::Billing::CreditCard.any_instance.stub(:valid?).and_return(false)
    fill_in "First Name", with: "Bean"
    fill_in "Last Name", with: "Salad"
    fill_in "Email Address", with: 'leamsdaf@example.com'
    select "01", from: "Card exp month"
    select "2017", from: "Card exp year"
    select "Master Card", from: "Card type"
    click_button "Complete Purchase"
    fill_in "Card Number", with: '4242424242424242'
    click_button "Complete Purchase"
    page.text.should_not include "declined"
    Order.count.should eq 1
  end
end
