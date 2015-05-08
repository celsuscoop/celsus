#encoding: utf-8
class Admin::VideosController < AdminController

 def index
    @videos = Video.in_title(params[:title])
                   .in_body(params[:body])
                   .in_owner(params[:owner_name])
                   .in_author(params[:author])
                   .in_remix(params[:remix])
                   .in_open(params[:open])
                   .in_main(params[:main])
                   .in_copyright(params[:copyright])
                   .order('created_at DESC').page(params[:page]).per(10)
  end

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    @video.user = current_user
    if @video.save
      redirect_to [:admin, @video]
    else
      render 'new'
    end
  end

  def edit
    @video = Video.find(params[:id])
    @video.copyright_extra = @video.copyright
  end

  def update
    @video = Video.find(params[:id])
    if @video.update(video_params)
      redirect_to [:admin, @video]
    else
      render 'edit'
    end
  end

  def show
    @video = Video.find(params[:id])
    @author_videos = Video.where(user_id: @video.user_id).where(is_open: true)
    @friendly_videos = @video.friendly_videos
    @activities = UserActivity.where(content_id: @video.id)
  end

  def destroy
    @video = Video.find(params[:id])
    @video.destroy
    redirect_to [:admin, :videos]
  end

  def toggle_main
    @video = Video.find(params[:video_id])
    @video.main = !@video.main
    @video.save
    respond_to do |format|
      format.html
      format.js
    end
  end

  def toggle_open
    @video = Video.find(params[:video_id])
    @video.is_open = !@video.is_open
    @video.save
    respond_to do |format|
      format.html
      format.js
    end
  end

  def remote_videos
    @videos = Video.remote_videos(page: params[:page])
    @page = params[:page] || 1
  end

  def fetch_remote_video
    video_id = params[:remote_video_uri].split('/').last
    @video = Video.create_from_remote(video_id, current_user.id)
    if @video.persisted?
      redirect_to [:edit, :admin, @video]
    else
      redirect_to :back, alert: @video.errors.full_messages.join(", ")
    end
  end

  def fetch_selected_remote_videos
    remote_video_ids = params[:video_ids]
    remote_video_ids.each do |video_id|
      Video.create_from_remote(video_id, current_user.id)
    end
    render json: {redirect_url: admin_videos_path}
  end

  def video_params
    params.require(:video).permit(:title, :body, :link, :file, :recommend, :is_open, :main, :user_id, :tag_list, :owner_name, :owner_url, {:parent_content_ids => []}, :is_remix, :extra_copyright, :copyright_extra, :copyright)
  end
end
