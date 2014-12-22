class EnterprisesController < ApplicationController
  before_action :set_enterprise, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @enterprises = Enterprise.all
    respond_with(@enterprises)
  end

  def show
    respond_with(@enterprise)
  end

  def new
    @enterprise = Enterprise.new
    respond_with(@enterprise)
  end

  def edit
  end

  def create
    @enterprise = Enterprise.new(enterprise_params)
    @enterprise.save
    
    redirect_to request.referer
  end

  def update
    @enterprise.update(enterprise_params)
    respond_with(@enterprise)
  end

  def destroy
    @enterprise.destroy
    respond_with(@enterprise)
  end

  private
    def set_enterprise
      @enterprise = Enterprise.find(params[:id])
    end

    def enterprise_params
      params.require(:enterprise).permit(:name)
    end
end
