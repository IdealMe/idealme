require 'spec_helper'

describe 'phase one', js: true, vcr: true do

  before :each do
  end

  context 'new user' do

    it 'flow', js: true, vcr: true do
      visit '/optin'
      sleep 1

      visit '/aweber_callback?email=charlie%2b22%40idealme%2ecom&from=charlie%2b22%40idealme%2ecom&listname=idealmeoptin&meta_adtracking=idealme%2ecom&meta_message=1&meta_required=email&meta_split_id=&meta_tooltip=&meta_web_form_id=58003487&name=&submit=Submit'
      expect(current_path).to eq "/upsell"
      screenshot true
    end
  end
end