require 'test_helper'

class Admin::PollsControllerTest < ActionController::TestCase
  setup do
    @admin_poll = admin_polls(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_polls)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_poll" do
    assert_difference('Admin::Poll.count') do
      post :create, admin_poll: {  }
    end

    assert_redirected_to admin_poll_path(assigns(:admin_poll))
  end

  test "should show admin_poll" do
    get :show, id: @admin_poll
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_poll
    assert_response :success
  end

  test "should update admin_poll" do
    put :update, id: @admin_poll, admin_poll: {  }
    assert_redirected_to admin_poll_path(assigns(:admin_poll))
  end

  test "should destroy admin_poll" do
    assert_difference('Admin::Poll.count', -1) do
      delete :destroy, id: @admin_poll
    end

    assert_redirected_to admin_polls_path
  end
end
