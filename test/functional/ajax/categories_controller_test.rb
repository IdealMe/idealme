require 'test_helper'

class Ajax::CategoriesControllerTest < ActionController::TestCase
  setup do
    @ajax_category = ajax_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ajax_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ajax_category" do
    assert_difference('Ajax::Category.count') do
      post :create, ajax_category: {  }
    end

    assert_redirected_to ajax_category_path(assigns(:ajax_category))
  end

  test "should show ajax_category" do
    get :show, id: @ajax_category
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ajax_category
    assert_response :success
  end

  test "should update ajax_category" do
    put :update, id: @ajax_category, ajax_category: {  }
    assert_redirected_to ajax_category_path(assigns(:ajax_category))
  end

  test "should destroy ajax_category" do
    assert_difference('Ajax::Category.count', -1) do
      delete :destroy, id: @ajax_category
    end

    assert_redirected_to ajax_categories_path
  end
end
