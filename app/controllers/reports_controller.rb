class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy]

  # GET /reports
  # GET /reports.json
  def index
    @reports = Report.all
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
  end

  # GET /reports/new
  def new
    @report = Report.new(user_id: params[:user_id], progress: params[:progress], task_id: params[:task_id])
  end

  # GET /reports/1/edit
  def edit
  end

  # POST /reports
  # POST /reports.json
  def create
    @report = Report.new(report_params)
    @project = @report.project

    respond_to do |format|
      if @report.save
        format.html { redirect_to request.referer }
        format.json { render :show, status: :created, location: @report }
        format.js 
      else
        format.html { render :new }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/1
  # PATCH/PUT /reports/1.json
  def update

    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to request.referer }
      else
        format.html { render :edit }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @project = @report.project
    @report_id = @report.id
    @report.destroy
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.json { head :no_content }
      format.js 
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_report
    @report = Report.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def report_params
    params.require(:report).permit(:task_id, :progress, :user_id)
  end
end
