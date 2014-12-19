class TasksController < ApplicationController
  load_and_authorize_resource
  before_action :set_task, only: [:show, :edit, :update, :destroy, :update_kanban_item_partial]

  # GET /tasks
  # GET /tasks.json
  def index
    @project = Project.find(params[:project_id])
    @tasks = @project.tasks
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /tasks/new
  def new
    # Creamos una tarea que tendra un proyecto, su padre y la fecha 
    @task = Task.new(project_id: params[:project_id])

    # hay veces que se crean tareas de primer nivel por lo que no tienen parent_id, solo corresponden al proyecto.
    if params[:parent_id]
      @task.expected_start_date = Task.find(params[:parent_id]).expected_start_date
      @task.parent_id = params[:parent_id]
    end

    respond_to do |format|
      format.html
    end
  end

  # GET /tasks/1/edit
  def edit

  end

  # POST /tasks
  def create
    @task = Task.new(task_params)
    respond_to do |format|
      if @task.save
        format.html { redirect_to project_tree_view_path(@task.project) }
        format.json { render :show, status: :created, location: @task }
        format.js 
      else
        format.html { redirect_to request.referer }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  def update
    @project = @task.project

    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to :back }
        format.js
      else
        format.html { redirect_to request.referer }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def list
    @comments = Comment.find(:all)
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy



    respond_to do |format|
      format.html { redirect_to request.referer }
    end
  end

  def delete_confirmation
    @task = Task.find(params[:task_id])
    respond_to do |format|
      format.js
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_task
    if params[:id]
      @task = Task.find(params[:id])
      @project = @task.project

    # cuando es llamada desde otro controlador
    elsif params[:task_id]
      @task = Task.find(params[:task_id])  
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def task_params
    params.require(:task).permit(:name, :expected_start_date, :expected_end_date,
                                 :start_date, :end_date, :parent_id, :level, :man_hours, :progress,
                                 :description, :duration, :deleted, :project_id, :user_id, :resources_cost, :resources)
  end
end
