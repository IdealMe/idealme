require 'test_helper'

class Admin::LecturesControllerTest < ActionController::TestCase
  setup do
    @admin_lecture = admin_lectures(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_lectures)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_lecture" do
    assert_difference('Admin::Lecture.count') do
      post :create, admin_lecture: {  }
    end

    assert_redirected_to admin_lecture_path(assigns(:admin_lecture))
  end

  test "should show admin_lecture" do
    get :show, id: @admin_lecture
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_lecture
    assert_response :success
  end

  test "should update admin_lecture" do
    put :update, id: @admin_lecture, admin_lecture: {  }
    assert_redirected_to admin_lecture_path(assigns(:admin_lecture))
  end

  test "should destroy admin_lecture" do
    assert_difference('Admin::Lecture.count', -1) do
      delete :destroy, id: @admin_lecture
    end

    assert_redirected_to admin_lectures_path
  end
end
