require 'spec_helper'

describe 'phase one' do
  before :each do
    #`rm /Users/charlie/Workspace/idealme/spec/fixtures/vcr_cassettes/phase_one/gets_to_continuity_offer_page.yml`
    path = 'spec/fixtures/vcr_cassettes/phase_one/gets_to_continuity_offer_page.yml'
    if File.exists?(path)
      File.delete(path)
    end
  end
  it 'gets to continuity offer page', js: true, vcr: true do

    ap "step 1"
    visit '/optin'
    ap "step 2"
    sleep 1
    ap "step 3"
    visit '/aweber_callback?email=charlie%2b22%40idealme%2ecom&from=charlie%2b22%40idealme%2ecom&listname=idealmeoptin&meta_adtracking=idealme%2ecom&meta_message=1&meta_required=email&meta_split_id=&meta_tooltip=&meta_web_form_id=58003487&name=&submit=Submit'
    ap "step 4"
    expect(current_path).to eq "/upsell"
    ap "step 5"
    submit_order_form
    ap "step 6"
    sleep 4
    ap "step 7"
    expect(current_path).to eq "/continuity-offer-1"
    ap "step 8"

    sleep 1
    ap "step 9"
    page.execute_script("$('#offer-container').removeClass('hidden')")
    sleep 1
    ap "step 10"
    click_button "Buy this thing"
    ap "step 11"
    #sleep 10
    #user = User.order("created_at ASC").last
    #expect(user.subscriptions.count).to eq 1
    #expect(user.subscriptions.last).to eq Subscription.first
    #screenshot true
  end
end
