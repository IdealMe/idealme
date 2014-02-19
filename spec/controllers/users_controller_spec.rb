require 'spec_helper'

describe UsersController do

  let!(:article)      { create(:article, drip_content: true, reveal_after_days: 1)}
  let!(:article2)     { create(:article, drip_content: true, reveal_after_days: 9)}
  let!(:article3)     { create(:article, drip_content: true, reveal_after_days: 29)}
  let(:user)          { create(:user) }
  let!(:subscription) { create(:subscription, user: user, subscribed_days: 2) }

  before :each do
    sign_in user
  end

  it "shows the user appropriate articles" do
    get :profile, id: user.username
    assigns[:modules].flatten.should include article
    assigns[:modules].flatten.should_not include article2
  end

  it "portions the articles into 28 day modules" do
    subscription.update_attribute :subscribed_days, 200
    get :profile, id: user.username
    assigns[:modules].length.should eq 2
  end

end
