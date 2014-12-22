class ProjectUsersController < ApplicationController
  before_action :set_project_user, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @project_users = ProjectUser.all
    respond_with(@project_users)
  end

  def show
    respond_with(@project_user)
  end

  def new
    @project_user = ProjectUser.new(project_id: params[:project_id], user_id: params[:user_id])
    respond_with(@project_user)
  end

  def edit
  end

  def create
    @project_user = ProjectUser.new(project_user_params)
    @project_user.save
    respond_with(@project_user)
  end

  def update
    @project_user.update(project_user_params)
    respond_with(@project_user)
  end

  def destroy
    @project_user.destroy
    respond_with(@project_user)
  end

  private
    def set_project_user
      @project_user = ProjectUser.find(params[:id])
    end

    def project_user_params
      params.require(:project_user).permit(:project_id, :user_id, :role)
    end
end
