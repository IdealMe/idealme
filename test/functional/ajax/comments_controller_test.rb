require 'test_helper'

class Ajax::CommentsControllerTest < ActionController::TestCase
  setup do
    @ajax_comment = ajax_comments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ajax_comments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ajax_comment" do
    assert_difference('Ajax::Comment.count') do
      post :create, ajax_comment: {  }
    end

    assert_redirected_to ajax_comment_path(assigns(:ajax_comment))
  end

  test "should show ajax_comment" do
    get :show, id: @ajax_comment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ajax_comment
    assert_response :success
  end

  test "should update ajax_comment" do
    put :update, id: @ajax_comment, ajax_comment: {  }
    assert_redirected_to ajax_comment_path(assigns(:ajax_comment))
  end

  test "should destroy ajax_comment" do
    assert_difference('Ajax::Comment.count', -1) do
      delete :destroy, id: @ajax_comment
    end

    assert_redirected_to ajax_comments_path
  end
end
