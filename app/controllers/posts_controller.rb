class PostsController < ApplicationController
  def index
    if params[:category].present?
      select_category = Category.where(name: params[:category]).first
      @posts = Post.where(category_id: select_category.id).order("created_at DESC").page(params[:page]).per(8)
    else
      @posts = Post.order("created_at DESC").page(params[:page]).per(8)
    end
    @categories = Category.all
  end
  def show
    @post = Post.find(params[:id])
  end
end
