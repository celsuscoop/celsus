class Admin::CategoriesController < AdminController
  def index
    @categories = Category.all
  end

  def create
    @category = Category.new category_params
    @category.save
    redirect_to admin_categories_path
  end

  def update
    @category = Category.find(params[:id])
    @category.update category_params
    redirect_to admin_categories_path
  end

  def destroy
    @category = Category.find(params[:id])
    if @category.posts.blank?
      @category.destroy
    end
    redirect_to :back
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end