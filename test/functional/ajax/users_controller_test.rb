require 'test_helper'

class Ajax::UsersControllerTest < ActionController::TestCase
  setup do
    @ajax_user = ajax_users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ajax_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ajax_user" do
    assert_difference('Ajax::User.count') do
      post :create, ajax_user: {  }
    end

    assert_redirected_to ajax_user_path(assigns(:ajax_user))
  end

  test "should show ajax_user" do
    get :show, id: @ajax_user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ajax_user
    assert_response :success
  end

  test "should update ajax_user" do
    put :update, id: @ajax_user, ajax_user: {  }
    assert_redirected_to ajax_user_path(assigns(:ajax_user))
  end

  test "should destroy ajax_user" do
    assert_difference('Ajax::User.count', -1) do
      delete :destroy, id: @ajax_user
    end

    assert_redirected_to ajax_users_path
  end
end
