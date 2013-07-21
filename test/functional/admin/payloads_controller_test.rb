require 'test_helper'

class Admin::PayloadsControllerTest < ActionController::TestCase
  setup do
    @admin_payload = admin_payloads(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_payloads)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_payload" do
    assert_difference('Admin::Payload.count') do
      post :create, admin_payload: {  }
    end

    assert_redirected_to admin_payload_path(assigns(:admin_payload))
  end

  test "should show admin_payload" do
    get :show, id: @admin_payload
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_payload
    assert_response :success
  end

  test "should update admin_payload" do
    put :update, id: @admin_payload, admin_payload: {  }
    assert_redirected_to admin_payload_path(assigns(:admin_payload))
  end

  test "should destroy admin_payload" do
    assert_difference('Admin::Payload.count', -1) do
      delete :destroy, id: @admin_payload
    end

    assert_redirected_to admin_payloads_path
  end
end
