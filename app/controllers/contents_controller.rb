class ContentsController < ApplicationController

  def index
    @contents = Content.where(is_open: true)
  end

  def search
    @contents = Content.where(is_open: true).in_query(params[:q]).in_copyright(params[:copyright]).page(params[:page]).per(16)
  end

  def tags
    if params[:tag].present?
      @contents = Content.tagged_with(params[:tag]).page(params[:page]).per(16)
    end
  end

end