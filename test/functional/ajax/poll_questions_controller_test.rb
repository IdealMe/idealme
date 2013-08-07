require 'test_helper'

class Ajax::PollQuestionsControllerTest < ActionController::TestCase
  setup do
    @ajax_poll_question = ajax_poll_questions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ajax_poll_questions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ajax_poll_question" do
    assert_difference('Ajax::PollQuestion.count') do
      post :create, ajax_poll_question: {  }
    end

    assert_redirected_to ajax_poll_question_path(assigns(:ajax_poll_question))
  end

  test "should show ajax_poll_question" do
    get :show, id: @ajax_poll_question
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ajax_poll_question
    assert_response :success
  end

  test "should update ajax_poll_question" do
    put :update, id: @ajax_poll_question, ajax_poll_question: {  }
    assert_redirected_to ajax_poll_question_path(assigns(:ajax_poll_question))
  end

  test "should destroy ajax_poll_question" do
    assert_difference('Ajax::PollQuestion.count', -1) do
      delete :destroy, id: @ajax_poll_question
    end

    assert_redirected_to ajax_poll_questions_path
  end
end
