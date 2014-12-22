require 'test_helper'

class PorjectUsersControllerTest < ActionController::TestCase
  setup do
    @porject_user = porject_users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:porject_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create porject_user" do
    assert_difference('PorjectUser.count') do
      post :create, porject_user: { project_id: @porject_user.project_id, role: @porject_user.role, user_id: @porject_user.user_id }
    end

    assert_redirected_to porject_user_path(assigns(:porject_user))
  end

  test "should show porject_user" do
    get :show, id: @porject_user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @porject_user
    assert_response :success
  end

  test "should update porject_user" do
    patch :update, id: @porject_user, porject_user: { project_id: @porject_user.project_id, role: @porject_user.role, user_id: @porject_user.user_id }
    assert_redirected_to porject_user_path(assigns(:porject_user))
  end

  test "should destroy porject_user" do
    assert_difference('PorjectUser.count', -1) do
      delete :destroy, id: @porject_user
    end

    assert_redirected_to porject_users_path
  end
end
