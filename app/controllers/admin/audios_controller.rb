#encoding: utf-8
class Admin::AudiosController < AdminController

  def index
    @audios = Audio.in_title(params[:title])
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
    @audio = Audio.new
  end

  def create
    @audio = Audio.new(audio_params)
    @audio.user = current_user
    if @audio.save
      redirect_to [:admin, @audio]
    else
      render 'new'
    end
  end

  def edit
    @audio = Audio.find(params[:id])
    @audio.copyright_extra = @audio.copyright
  end

  def update
    @audio = Audio.find(params[:id])
    if @audio.update(audio_params)
      redirect_to [:admin, @audio]
    else
      render 'edit'
    end
  end

  def show
    @audio = Audio.find(params[:id])
    @author_audios = Audio.where(user_id: @audio.user_id).where(is_open: true)
    @friendly_audios = @audio.friendly_audios
    @activities = UserActivity.where(content_id: @audio.id)
  end

  def destroy
    @audio = Audio.find(params[:id])
    @audio.destroy
    redirect_to [:admin, :audios]
  end

  def toggle_main
    @audio = Audio.find(params[:audio_id])
    @audio.main = !@audio.main
    @audio.save
    respond_to do |format|
      format.html
      format.js
    end
  end

  def toggle_open
    @audio = Audio.find(params[:audio_id])
    @audio.is_open = !@audio.is_open
    @audio.save
    respond_to do |format|
      format.html
      format.js
    end
  end

  def remote_audios
    @audios = Audio.remote_audios
  end

  def fetch_remote_audio
    audio_id = params[:remote_audio_id]
    @audio = Audio.create_from_remote(audio_id, current_user.id)
    if @audio.persisted?
      redirect_to [:edit, :admin, @audio]
    else
      redirect_to :back, alert: @audio.errors.full_messages.join(", ")
    end
  end

  def fetch_selected_remote_audios
    remote_audio_ids = params[:audio_ids]
    remote_audio_ids.each do |audio_id|
      Audio.create_from_remote(audio_id, current_user.id)
    end
    render json: {redirect_url: admin_audios_path}
  end

  def audio_params
    params.require(:audio).permit(:title, :body, :link, :file, :recommend, :is_open, :main, {:parent_content_ids => []}, :user_id, :tag_list, :owner_name, :owner_url, :is_remix, :extra_copyright, :copyright_extra, :copyright, :remote_content_id)
  end
end
