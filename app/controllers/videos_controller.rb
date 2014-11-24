#encoding: utf-8

class VideosController < ApplicationController

  def index
    @main_videos = Video.where(main: true).where(is_open: true).order("created_at DESC").limit(5)
    @videos = Video.where(is_open: true).page(params[:page]).order("created_at DESC").per(8)
  end

  def new
    @video = Video.new
    @video.is_remix = true
    authorize! :create, @video
  end

  def create
    @video = Video.new video_params
    @video.user = current_user
    if @video.save
      redirect_to root_url, notice: '비디오가 성공적으로 등록되었습니다. 관리자 승인 후 노출됩니다.'
    else
      render 'new'
    end
  end

  def edit
    @video = Video.find(params[:id])
  end

  def update
    @video = Video.find(params[:id])
    @video.update(video_params)
    if @video.save
      redirect_to @video
    else
      render 'edit'
    end
  end

  def show
    @video = Video.find(params[:id])
    @video.view = @video.view + 1
    @video.save

    @author_videos = Video.where(user_id: @video.user_id).where(is_open: true)
    @friendly_videos = @video.friendly_videos

    @warning = Warning.new
    @content = @video
  end

  def download
    @video = Video.find(params[:video_id])
    authorize! :download, @video
    @video.increase_download_count(current_user)
    redirect_to @video.download_url(params[:type_quality])
  end

  def video_params
    params.require(:video).permit(:title, :body, :link, :file, :recommend, {:parent_content_ids => []}, :user_id, :tag_list, :is_remix, :owner_name, :owner_url, :extra_copyright, :copyright_extra, :copyright)
  end
end