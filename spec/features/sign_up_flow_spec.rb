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

describe 'sign up flow' do

  let!(:user)               { create(:user) }
  let!(:link)               { create(:affiliate_link) }
  let!(:affiliate_user)     { link.user }
  let!(:market)             { create(:market, course: course) }
  let!(:course)             { create(:course, owner: affiliate_user) }
  let!(:market2)            { create(:market2, course: course2) }
  let!(:course2)            { create(:course2, owner: affiliate_user) }

  it 'send the user to the create account screen', js: true, vcr: true do
    visit '/aweber_callback?email=charlie%2b22%40idealme%2ecom&from=charlie%2b22%40idealme%2ecom&listname=idealmeoptin&meta_adtracking=idealme%2ecom&meta_message=1&meta_required=email&meta_split_id=&meta_tooltip=&meta_web_form_id=58003487&name=&submit=Submit'

    page.path.should eq '/asdfsf/'
  end

end
