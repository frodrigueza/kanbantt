require 'test_helper'

class ResourcesReportsControllerTest < ActionController::TestCase
  setup do
    @resources_report = resources_reports(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:resources_reports)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create resources_report" do
    assert_difference('ResourcesReport.count') do
      post :create, resources_report: { resources: @resources_report.resources, task_id: @resources_report.task_id, user_id: @resources_report.user_id }
    end

    assert_redirected_to resources_report_path(assigns(:resources_report))
  end

  test "should show resources_report" do
    get :show, id: @resources_report
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @resources_report
    assert_response :success
  end

  test "should update resources_report" do
    patch :update, id: @resources_report, resources_report: { resources: @resources_report.resources, task_id: @resources_report.task_id, user_id: @resources_report.user_id }
    assert_redirected_to resources_report_path(assigns(:resources_report))
  end

  test "should destroy resources_report" do
    assert_difference('ResourcesReport.count', -1) do
      delete :destroy, id: @resources_report
    end

    assert_redirected_to resources_reports_path
  end
end
