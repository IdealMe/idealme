require 'test_helper'

class DiscoversControllerTest < ActionController::TestCase
  setup do
    @discover = discovers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:discovers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create discover" do
    assert_difference('Discover.count') do
      post :create, discover: {  }
    end

    assert_redirected_to discover_path(assigns(:discover))
  end

  test "should show discover" do
    get :show, id: @discover
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @discover
    assert_response :success
  end

  test "should update discover" do
    put :update, id: @discover, discover: {  }
    assert_redirected_to discover_path(assigns(:discover))
  end

  test "should destroy discover" do
    assert_difference('Discover.count', -1) do
      delete :destroy, id: @discover
    end

    assert_redirected_to discovers_path
  end
end
