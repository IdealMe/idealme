require 'test_helper'

class Ajax::PollResultsControllerTest < ActionController::TestCase
  setup do
    @ajax_poll_result = ajax_poll_results(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ajax_poll_results)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ajax_poll_result" do
    assert_difference('Ajax::PollResult.count') do
      post :create, ajax_poll_result: {  }
    end

    assert_redirected_to ajax_poll_result_path(assigns(:ajax_poll_result))
  end

  test "should show ajax_poll_result" do
    get :show, id: @ajax_poll_result
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ajax_poll_result
    assert_response :success
  end

  test "should update ajax_poll_result" do
    put :update, id: @ajax_poll_result, ajax_poll_result: {  }
    assert_redirected_to ajax_poll_result_path(assigns(:ajax_poll_result))
  end

  test "should destroy ajax_poll_result" do
    assert_difference('Ajax::PollResult.count', -1) do
      delete :destroy, id: @ajax_poll_result
    end

    assert_redirected_to ajax_poll_results_path
  end
end
