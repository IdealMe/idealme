require 'spec_helper'

describe 'sign up flow with workbook purchase' do

  let!(:user)               { create(:user) }
  let!(:link)               { create(:affiliate_link) }
  let!(:affiliate_user)     { link.user }
  let!(:market)             { create(:market, course: course) }
  let!(:course)             { create(:course, owner: affiliate_user) }
  let!(:market2)            { create(:market2, course: course2) }
  let!(:course2)            { create(:course2, owner: affiliate_user) }
  let!(:goal)               { create(:goal) }

  def visit_workbook
    visit root_path
    visit '/aweber_callback?email=charlie%2b22%40idealme%2ecom&from=charlie%2b22%40idealme%2ecom&listname=idealmeoptin&meta_adtracking=idealme%2ecom&meta_message=1&meta_required=email&meta_split_id=&meta_tooltip=&meta_web_form_id=58003487&name=&submit=Submit'
    page.current_path.should eq '/workbook'
  end

  it 'when user has account but is not signed in', js: true, vcr: true do
    visit_workbook
    submit_order_form(email: user.email)
    page.current_path.should eq '/login'
    fill_in "Email", with: user.email
    fill_in "Password", with: "passpass"
    click_button "Sign in"
    page.current_path.should eq '/orders/new/workbook'
    submit_order_form(email: user.email)
    Order.count.should eq 1
  end

  it 'declined card', js: true, vcr: true do
    visit_workbook
    submit_order_form(card_number: '4000000000000002')
    page.text.should include "declined"
    submit_order_form(card_number: '4242424242424242')
    page.text.should_not include "declined"
    Order.count.should eq 1
  end
end
