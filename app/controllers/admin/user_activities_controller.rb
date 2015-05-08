class Admin::UserActivitiesController < AdminController

  def index
    if params[:content_id].present?
      user_activity = UserActivity.where(content_id: params[:content_id])
    else
      user_activity = UserActivity.all
    end
    @activities = user_activity.order('created_at DESC').page(params[:page]).per(10)


  end

end