class ResourcesReportsController < ApplicationController
  before_action :set_resources_report, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @resources_reports = ResourcesReport.all

  end

  def show

  end

  def new
    @resources_report = ResourcesReport.new
  end

  def edit
  end

  def create
    @resources_report = ResourcesReport.new(resources_report_params)

    respond_to do |format|

      if @resources_report.save
        format.html { redirect_to @resources_report }
        format.json { render :show, status: :created, location: @resources_report }
      else
        format.html { render :new }
        format.json { render json: @resources_report.errors, status: :unprocessable_entity }
      end
    end

  end

  def update

    respond_to do |format|
      if @resources_report.update(resources_report_params)
        format.html { redirect_to @resources_report }
      else
        format.html { render :edit }
        format.json { render json: @resources_report.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @resources_report.destroy
    respond_with(@resources_report)
  end

  private
  def set_resources_report
    @resources_report = ResourcesReport.find(params[:id])
  end

  def resources_report_params
    params.require(:resources_report).permit(:task_id, :resources, :user_id)
  end
end
