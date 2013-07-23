require 'test_helper'

class Ajax::GoalsControllerTest < ActionController::TestCase
  setup do
    @ajax_goal = ajax_goals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ajax_goals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ajax_goal" do
    assert_difference('Ajax::Goal.count') do
      post :create, ajax_goal: {  }
    end

    assert_redirected_to ajax_goal_path(assigns(:ajax_goal))
  end

  test "should show ajax_goal" do
    get :show, id: @ajax_goal
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ajax_goal
    assert_response :success
  end

  test "should update ajax_goal" do
    put :update, id: @ajax_goal, ajax_goal: {  }
    assert_redirected_to ajax_goal_path(assigns(:ajax_goal))
  end

  test "should destroy ajax_goal" do
    assert_difference('Ajax::Goal.count', -1) do
      delete :destroy, id: @ajax_goal
    end

    assert_redirected_to ajax_goals_path
  end
end
