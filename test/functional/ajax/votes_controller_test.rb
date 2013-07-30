require 'test_helper'

class Ajax::VotesControllerTest < ActionController::TestCase
  setup do
    @ajax_vote = ajax_votes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ajax_votes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ajax_vote" do
    assert_difference('Ajax::Vote.count') do
      post :create, ajax_vote: {  }
    end

    assert_redirected_to ajax_vote_path(assigns(:ajax_vote))
  end

  test "should show ajax_vote" do
    get :show, id: @ajax_vote
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ajax_vote
    assert_response :success
  end

  test "should update ajax_vote" do
    put :update, id: @ajax_vote, ajax_vote: {  }
    assert_redirected_to ajax_vote_path(assigns(:ajax_vote))
  end

  test "should destroy ajax_vote" do
    assert_difference('Ajax::Vote.count', -1) do
      delete :destroy, id: @ajax_vote
    end

    assert_redirected_to ajax_votes_path
  end
end
