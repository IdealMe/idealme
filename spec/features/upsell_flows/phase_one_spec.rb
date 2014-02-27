require 'spec_helper'

describe 'phase one upsell flows' do

  it 'purchase workbook and subscription', js: true, vcr: true do
    visit '/optin'
    sleep 0.1
    visit '/aweber_callback?email=charlie%2b22%40idealme%2ecom&from=charlie%2b22%40idealme%2ecom&listname=idealmeoptin&meta_adtracking=idealme%2ecom&meta_message=1&meta_required=email&meta_split_id=&meta_tooltip=&meta_web_form_id=58003487&name=&submit=Submit'
    expect(current_path).to eq "/upsell"
    submit_order_form
    expect(current_path).to eq "/continuity-offer-1"
    page.execute_script("$('#offer-container').removeClass('hidden')")
    sleep 0.1
    find('#purchase-offer-btn').click
    sleep 2
    user = User.order("created_at ASC").last
    expect(user.subscriptions.count).to eq 1
    expect(user.subscriptions.last).to eq Subscription.first
    expect(current_path).to eq "/thanks/thank-you-a"
  end

  it 'decline workbook; purchase subscription', js: true, vcr: true do
    visit '/optin'
    sleep 0.1
    visit '/aweber_callback?email=charlie%2b22%40idealme%2ecom&from=charlie%2b22%40idealme%2ecom&listname=idealmeoptin&meta_adtracking=idealme%2ecom&meta_message=1&meta_required=email&meta_split_id=&meta_tooltip=&meta_web_form_id=58003487&name=&submit=Submit'
    expect(current_path).to eq "/upsell"
    click_link "No thanks"
    expect(current_path).to eq "/continuity-offer-1"
    page.execute_script("$('#offer-container').removeClass('hidden')")
    sleep 1

    submit_order_form(email: 'newguy1000@idealme.com')
    sleep 1

    user = User.where(email: 'newguy1000@idealme.com').order("created_at ASC").last
    expect(user.subscriptions.count).to eq 1
    expect(user.subscriptions.last).to eq Subscription.first
    expect(current_path).to eq "/thanks/thank-you-b"
  end

  it 'decline workbook; decline continuity-offer-1; purchase trial subscription', js: true, vcr: true do
    visit '/optin'
    sleep 0.1
    visit '/aweber_callback?email=charlie%2b22%40idealme%2ecom&from=charlie%2b22%40idealme%2ecom&listname=idealmeoptin&meta_adtracking=idealme%2ecom&meta_message=1&meta_required=email&meta_split_id=&meta_tooltip=&meta_web_form_id=58003487&name=&submit=Submit'
    expect(current_path).to eq "/upsell"
    click_link "No thanks"
    expect(current_path).to eq "/continuity-offer-1"
    page.execute_script("$('#offer-container').removeClass('hidden')")
    sleep 1

    click_link "No thanks"
    expect(current_path).to eq "/continuity-offer-2"

    submit_order_form(email: 'newguy1000@idealme.com')

    user = User.where(email: 'newguy1000@idealme.com').order("created_at ASC").last
    expect(user.subscriptions.count).to eq 1
    expect(user.subscriptions.last).to eq Subscription.first
    expect(current_path).to eq "/thanks/thank-you-b"
  end

  it "decline workbook, decline subscription", js: true, vcr: true do
    visit '/optin'
    sleep 0.1
    visit '/aweber_callback?email=charlie%2b22%40idealme%2ecom&from=charlie%2b22%40idealme%2ecom&listname=idealmeoptin&meta_adtracking=idealme%2ecom&meta_message=1&meta_required=email&meta_split_id=&meta_tooltip=&meta_web_form_id=58003487&name=&submit=Submit'
    expect(current_path).to eq "/upsell"

    click_link "No thanks"
    expect(current_path).to eq "/continuity-offer-1"

    click_link "No thanks"
    expect(current_path).to eq "/continuity-offer-2"

    page.execute_script("$('#offer-container').removeClass('hidden')")
    sleep 0.1

    click_link "No thanks"

    expect(current_path).to eq "/thanks/thank-you-c"
  end
end
