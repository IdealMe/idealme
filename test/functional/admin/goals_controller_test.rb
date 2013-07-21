require 'test_helper'

class Admin::GoalsControllerTest < ActionController::TestCase
  setup do
    @admin_goal = admin_goals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_goals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_goal" do
    assert_difference('Admin::Goal.count') do
      post :create, admin_goal: {  }
    end

    assert_redirected_to admin_goal_path(assigns(:admin_goal))
  end

  test "should show admin_goal" do
    get :show, id: @admin_goal
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_goal
    assert_response :success
  end

  test "should update admin_goal" do
    put :update, id: @admin_goal, admin_goal: {  }
    assert_redirected_to admin_goal_path(assigns(:admin_goal))
  end

  test "should destroy admin_goal" do
    assert_difference('Admin::Goal.count', -1) do
      delete :destroy, id: @admin_goal
    end

    assert_redirected_to admin_goals_path
  end
end
