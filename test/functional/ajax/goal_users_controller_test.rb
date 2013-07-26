require 'test_helper'

class Ajax::GoalUsersControllerTest < ActionController::TestCase
  setup do
    @ajax_goal_user = ajax_goal_users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ajax_goal_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ajax_goal_user" do
    assert_difference('Ajax::GoalUser.count') do
      post :create, ajax_goal_user: {  }
    end

    assert_redirected_to ajax_goal_user_path(assigns(:ajax_goal_user))
  end

  test "should show ajax_goal_user" do
    get :show, id: @ajax_goal_user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ajax_goal_user
    assert_response :success
  end

  test "should update ajax_goal_user" do
    put :update, id: @ajax_goal_user, ajax_goal_user: {  }
    assert_redirected_to ajax_goal_user_path(assigns(:ajax_goal_user))
  end

  test "should destroy ajax_goal_user" do
    assert_difference('Ajax::GoalUser.count', -1) do
      delete :destroy, id: @ajax_goal_user
    end

    assert_redirected_to ajax_goal_users_path
  end
end
