require 'spec_helper'

describe UsersController do

  let!(:article) {create(:article, drip_content: true, reveal_after_days: 0)}
  let!(:hidden_article) {create(:article, drip_content: true, reveal_after_days: 9)}
  let(:user)           { create(:user) }
  let!(:subscription) { create(:subscription, user: user) }

  before :each do
    sign_in user
  end

  it "shows the user appropriate articles" do
    get :profile
    assigns[:drip_articles].should include article
    assigns[:drip_articles].should_not include hidden_article
  end
end
