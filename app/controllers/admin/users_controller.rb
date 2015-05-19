class Admin::UsersController < AdminController

  def index
    @users = User.order('created_at DESC').page(params[:page]).per(10)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to [:admin, :users]
    else
      render 'edit'
    end
  end

  def user_params
    params.require(:user).permit(:role)
  end
end