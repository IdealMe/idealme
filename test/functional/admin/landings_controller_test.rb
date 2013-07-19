require 'test_helper'

class Admin::LandingsControllerTest < ActionController::TestCase
  setup do
    @admin_landing = admin_landings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_landings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_landing" do
    assert_difference('Admin::Landing.count') do
      post :create, admin_landing: {  }
    end

    assert_redirected_to admin_landing_path(assigns(:admin_landing))
  end

  test "should show admin_landing" do
    get :show, id: @admin_landing
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_landing
    assert_response :success
  end

  test "should update admin_landing" do
    put :update, id: @admin_landing, admin_landing: {  }
    assert_redirected_to admin_landing_path(assigns(:admin_landing))
  end

  test "should destroy admin_landing" do
    assert_difference('Admin::Landing.count', -1) do
      delete :destroy, id: @admin_landing
    end

    assert_redirected_to admin_landings_path
  end
end
