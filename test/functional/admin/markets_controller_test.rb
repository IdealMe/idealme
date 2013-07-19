require 'test_helper'

class Admin::MarketsControllerTest < ActionController::TestCase
  setup do
    @admin_market = admin_markets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_markets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_market" do
    assert_difference('Admin::Market.count') do
      post :create, admin_market: {  }
    end

    assert_redirected_to admin_market_path(assigns(:admin_market))
  end

  test "should show admin_market" do
    get :show, id: @admin_market
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_market
    assert_response :success
  end

  test "should update admin_market" do
    put :update, id: @admin_market, admin_market: {  }
    assert_redirected_to admin_market_path(assigns(:admin_market))
  end

  test "should destroy admin_market" do
    assert_difference('Admin::Market.count', -1) do
      delete :destroy, id: @admin_market
    end

    assert_redirected_to admin_markets_path
  end
end
