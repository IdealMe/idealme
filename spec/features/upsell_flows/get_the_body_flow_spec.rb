
require 'spec_helper'

describe 'get the body flow', js: true, vcr: true do

  let!(:user)               { create(:user) }
  let!(:link)               { create(:affiliate_link) }
  let!(:affiliate_user)     { link.user }
  let!(:market)             { create(:market, course: course) }
  let!(:course)             { create(:course, owner: affiliate_user) }
  let!(:market2)            { create(:market2, course: course2) }
  let!(:course2)            { create(:course2, owner: affiliate_user) }
  let!(:goal)               { create(:goal) }

  before :each do
    ActiveMerchant::Billing::CreditCard.any_instance.stub(:valid?).and_return(true)
  end

  it 'anonymous user', js: true, vcr: true do
    visit '/get-the-body'
    expect(page).to have_css "form.af-form-wrapper"

    visit '/aweber_callback?email=charlie%2b22%40idealme%2ecom&from=charlie%2b22%40idealme%2ecom&listname=idealmeoptin&meta_adtracking=idealme%2ecom&meta_message=1&meta_required=email&meta_split_id=&meta_tooltip=&meta_web_form_id=58003487&name=&submit=Submit'
    expect(page).to_not have_css "form.af-form-wrapper"
    expect(current_path).to eq '/get-the-body'

    fill_in "Card Number", with: '4242424242424242'
    fill_in "Security Code", with: '123'
    fill_in "First Name", with: "Bean"
    fill_in "Last Name", with: "Salad"

    select "01", from: "Card exp month"
    select "2017", from: "Card exp year"
    select "Master Card", from: "Card type"
    click_button "Complete Purchase"

    expect(page.current_path).to eq '/workbook-thanks'
    expect(emails.length).to eq 2
  end
end
