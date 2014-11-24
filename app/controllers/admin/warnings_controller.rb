#encoding: utf-8

class Admin::WarningsController < AdminController
  def index
    @warnings = Warning.all
  end

  def show
    @warning = Warning.find(params[:id])
  end

  def destroy
    @warning = Warning.find(params[:id])
    @warning.destroy
    redirect_to [:admin, :warnings]
  end
end