require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

describe 'editing articles/resources' do

  let!(:user)               { create(:user) }
  let!(:admin)              { create(:user_admin) }
  let!(:link)               { create(:affiliate_link) }
  let!(:affiliate_user)     { link.user }
  let!(:market)             { create(:market, course: course) }
  let!(:course)             { create(:course, owner: affiliate_user) }
  let!(:goal)               { create(:goal) }
  let!(:article)            { Article.create(name: "test article", content: "test content") }

  before :each do
    login_as(admin, scope: :user)
  end

  it 'editing article goals', js: true do
    visit '/admin/articles/test-article/edit'
    select(goal.name)
    click_button "Save"
    article.goals.to_a.should include goal
  end

end
