require 'test_helper'

class Ajax::CheckinsControllerTest < ActionController::TestCase
  setup do
    @ajax_checkin = ajax_checkins(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ajax_checkins)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ajax_checkin" do
    assert_difference('Ajax::Checkin.count') do
      post :create, ajax_checkin: {  }
    end

    assert_redirected_to ajax_checkin_path(assigns(:ajax_checkin))
  end

  test "should show ajax_checkin" do
    get :show, id: @ajax_checkin
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ajax_checkin
    assert_response :success
  end

  test "should update ajax_checkin" do
    put :update, id: @ajax_checkin, ajax_checkin: {  }
    assert_redirected_to ajax_checkin_path(assigns(:ajax_checkin))
  end

  test "should destroy ajax_checkin" do
    assert_difference('Ajax::Checkin.count', -1) do
      delete :destroy, id: @ajax_checkin
    end

    assert_redirected_to ajax_checkins_path
  end
end
