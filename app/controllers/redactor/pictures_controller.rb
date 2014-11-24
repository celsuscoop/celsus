class Redactor::PicturesController < ApplicationController
  def index
  end

  def create
    @picture = Redactor::Picture.new(data: params[:file])
    @picture.save
    render json: { filelink: @picture.data.url }
  end
end