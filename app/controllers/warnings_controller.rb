#encoding: utf-8
class WarningsController < ApplicationController

  def new
    @warning = Warning.new
  end

  def create
    @warning = Warning.new warning_params
    @warning.user = current_user
    if @warning.save
      redirect_to @warning.content
    else
      render 'new'
    end
  end

  def show
    @warning = Warning.find(params[:id])
  end

  def warning_params
    params.require(:warning).permit(:cause, :content_id, :user_id)
  end
end