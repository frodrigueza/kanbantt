require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  setup do
    @task = tasks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tasks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create task" do
    assert_difference('Task.count') do
      post :create, task: { deleted: @task.deleted, description: @task.description, end_date: @task.end_date, expected_end_date: @task.expected_end_date, expected_start_date: @task.expected_start_date, man_hours: @task.man_hours, name: @task.name, level: @task.level, parent_id: @task.parent_id, progress: @task.progress, project_id: @task.project_id, start_date: @task.start_date }
    end

    assert_redirected_to task_path(assigns(:task))
  end

  test "should show task" do
    get :show, id: @task
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @task
    assert_response :success
  end

  test "should update task" do
    patch :update, id: @task, task: { deleted: @task.deleted, description: @task.description, end_date: @task.end_date, expected_end_date: @task.expected_end_date, expected_start_date: @task.expected_start_date, man_hours: @task.man_hours, name: @task.name, level: @task.level, parent_id: @task.parent_id, progress: @task.progress, project_id: @task.project_id, start_date: @task.start_date }
    assert_redirected_to task_path(assigns(:task))
  end

  test "should destroy task" do
    assert_difference('Task.count', -1) do
      delete :destroy, id: @task
    end

    assert_redirected_to tasks_path
  end
end
