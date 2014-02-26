require 'spec_helper'

describe 'phase one' do
  before :each do
    #`rm /Users/charlie/Workspace/idealme/spec/fixtures/vcr_cassettes/phase_one/gets_to_continuity_offer_page.yml`
    path = 'spec/fixtures/vcr_cassettes/phase_one/gets_to_continuity_offer_page.yml'
    if File.exists?(path)
      #File.delete(path)
    end
  end

  it 'purchase workbook and subscription', js: true, vcr: true do
    visit '/optin'
    sleep 0.1
    visit '/aweber_callback?email=charlie%2b22%40idealme%2ecom&from=charlie%2b22%40idealme%2ecom&listname=idealmeoptin&meta_adtracking=idealme%2ecom&meta_message=1&meta_required=email&meta_split_id=&meta_tooltip=&meta_web_form_id=58003487&name=&submit=Submit'
    expect(current_path).to eq "/upsell"
    submit_order_form
    expect(current_path).to eq "/continuity-offer-1"
    page.execute_script("$('#offer-container').removeClass('hidden')")
    sleep 0.1
    check "I confirm"
    click_button "Confirm purchase"
    sleep 0.2
    user = User.order("created_at ASC").last
    expect(user.subscriptions.count).to eq 1
    expect(user.subscriptions.last).to eq Subscription.first
    expect(current_path).to eq "/thanks/subscriber"
  end

  it 'decline workbook; purchase subscription', js: true, vcr: true do
    pending "not implemented"
    visit '/optin'
    sleep 0.1
    visit '/aweber_callback?email=charlie%2b22%40idealme%2ecom&from=charlie%2b22%40idealme%2ecom&listname=idealmeoptin&meta_adtracking=idealme%2ecom&meta_message=1&meta_required=email&meta_split_id=&meta_tooltip=&meta_web_form_id=58003487&name=&submit=Submit'
    expect(current_path).to eq "/upsell"
    click "Decline offer"
    expect(current_path).to eq "/continuity-offer-1"
    page.execute_script("$('#offer-container').removeClass('hidden')")
    sleep 1
    screenshot true


    user = User.order("created_at ASC").last
    expect(user.subscriptions.count).to eq 1
    expect(user.subscriptions.last).to eq Subscription.first
    expect(current_path).to eq "/thanks/subscriber"
  end
end
