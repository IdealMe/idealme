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
    submit_order_form(email: user.email)
    page.current_path.should eq '/login'
    fill_in "Email", with: user.email
    fill_in "Password", with: "passpass"
    click_button "Sign in"
    page.current_path.should eq '/orders/new/workbook'
    submit_order_form(email: user.email)
    screenshot true
    Order.count.should eq 1
  end

  it 'send the user to the create account screen', js: true, vcr: true do
    visit '/getthebook'
    visit '/aweber_callback?email=charlie%2b22%40idealme%2ecom&from=charlie%2b22%40idealme%2ecom&listname=idealmeoptin&meta_adtracking=idealme%2ecom&meta_message=1&meta_required=email&meta_split_id=&meta_tooltip=&meta_web_form_id=58003487&name=&submit=Submit'
    page.current_path.should eq '/getthebook'
    find('#getthebook-btn').click
    page.current_path.should eq '/orders/new/workbook'
    submit_order_form
    expect(current_path).to eq '/workbook-thanks'
    expect(Order.count).to eq 1

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
    submit_order_form(card_number: '4000000000000002')
    page.text.should include "declined"
    submit_order_form(card_number: '4242424242424242')
    page.text.should_not include "declined"
    Order.count.should eq 1
  end
end
