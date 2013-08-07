require 'test_helper'

class Admin::ArticlesControllerTest < ActionController::TestCase
  setup do
    @admin_article = admin_articles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_articles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_article" do
    assert_difference('Admin::Article.count') do
      post :create, admin_article: {  }
    end

    assert_redirected_to admin_article_path(assigns(:admin_article))
  end

  test "should show admin_article" do
    get :show, id: @admin_article
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_article
    assert_response :success
  end

  test "should update admin_article" do
    put :update, id: @admin_article, admin_article: {  }
    assert_redirected_to admin_article_path(assigns(:admin_article))
  end

  test "should destroy admin_article" do
    assert_difference('Admin::Article.count', -1) do
      delete :destroy, id: @admin_article
    end

    assert_redirected_to admin_articles_path
  end
end
