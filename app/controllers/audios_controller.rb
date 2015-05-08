#encoding: utf-8

class AudiosController < ApplicationController

  def index
    @main_audios = Audio.where(main: true).where(is_open: true).order("created_at DESC").limit(5)
    @audios = Audio.where(is_open: true).order("created_at DESC").page(params[:page]).per(8)
  end

  def new
    @audio = Audio.new
    @audio.is_remix = true
    authorize! :create, @audio
  end

  def create
    @audio = Audio.new audio_params
    @audio.user = current_user
    if @audio.save
      redirect_to root_url, notice: '오디오가 성공적으로 등록되었습니다. 관리자 승인 후 노출됩니다.'
    else
      render 'new'
    end
  end

  def show
    @audio = Audio.find(params[:id])
    @audio.view = @audio.view + 1
    @audio.save

    @author_audios = Audio.where(user_id: @audio.user_id).where(is_open: true)
    @friendly_audios = @audio.friendly_audios

    @warning = Warning.new
    @content = @audio
  end

  def download
    @audio = Audio.find(params[:audio_id])
    authorize! :download, @audio
    @audio.increase_download_count(current_user)
    redirect_to @audio.download_url
  end

  def audio_params
    params.require(:audio).permit(:title, :body, :link, :file, :recommend, {:parent_content_ids => []}, :user_id, :tag_list, :is_remix, :owner_name, :owner_url, :extra_copyright, :copyright_extra, :copyright )
  end
end