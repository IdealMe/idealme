require 'spec_helper'

describe GoalsController do
  before :each do
    sign_in user
  end

  let(:goal)           { create(:goal) }
  let(:user)           { create(:user) }
  let!(:course_jewel)  { create(:course_jewel, goal_id: goal.id) }
  let!(:article_jewel) { create(:article_jewel, goal_id: goal.id) }
  let!(:app_jewel)     { create(:app_jewel, goal_id: goal.id) }
  let!(:product_jewel) { create(:product_jewel, goal_id: goal.id) }
  let!(:video_jewel)   { create(:video_jewel, goal_id: goal.id) }

  let!(:saved_jewel)   { create(:saved_jewel, jewel: app_jewel, user: user) }

  it 'filters by all' do
    get :filter, filter_name: :all, id: goal.slug
    assigns[:jewels].should include course_jewel
    assigns[:jewels].should include article_jewel
    assigns[:jewels].should include app_jewel
    assigns[:jewels].should include product_jewel
    assigns[:jewels].should include video_jewel
  end

  it 'filters by courses' do
    get :filter, filter_name: :course, id: goal.slug
    assigns[:jewels].should eq [course_jewel]
  end

  it 'filters by articles' do
    get :filter, filter_name: :article, id: goal.slug
    assigns[:jewels].should eq [article_jewel]
  end

  it 'filters by apps' do
    get :filter, filter_name: :app, id: goal.slug
    assigns[:jewels].should eq [app_jewel]
  end

  it 'filters by product' do
    get :filter, filter_name: :product, id: goal.slug
    assigns[:jewels].should eq [product_jewel]
  end

  it 'filters by video' do
    get :filter, filter_name: :video, id: goal.slug
    assigns[:jewels].should eq [video_jewel]
  end

  it 'filters by saved' do
    get :filter, filter_name: :saved, id: goal.slug
    assigns[:jewels].should eq [app_jewel]
  end
end
