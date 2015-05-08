#encoding: utf-8
class Admin::ImagesController < AdminController
  def index
    @images = Image.in_title(params[:title])
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
    @image = Image.new
  end

  def create
    @image = Image.new(image_params)
    @image.user = current_user
    if @image.save
      redirect_to [:admin, @image]
    else
      render 'new'
    end
  end

  def edit
    @image = Image.find(params[:id])
    @image.copyright_extra = @image.copyright
  end

  def update
    @image = Image.find(params[:id])
    if @image.update(image_params)
      redirect_to [:admin, @image]
    else
      render 'edit'
    end
  end

  def show
    @image = Image.find(params[:id])
    @author_images = Image.where(user_id: @image.user_id).where(is_open: true)
    @friendly_images = @image.friendly_images
    @activities = UserActivity.where(content_id: @image.id)
  end

  def destroy
    @image = Image.find(params[:id])
    @image.destroy
    redirect_to [:admin, :images]
  end

  def toggle_main
    @image = Image.find(params[:image_id])
    @image.main = !@image.main
    @image.save
    respond_to do |format|
      format.html
      format.js
    end
  end

  def toggle_open
    @image = Image.find(params[:image_id])
    @image.is_open = !@image.is_open
    @image.save
    respond_to do |format|
      format.html
      format.js
    end
  end

  def remote_images
    @images = Image.remote_images
  end

  def fetch_remote_image
    image_id = params[:image_id]
    @image = Image.create_from_remote(image_id, current_user.id)
    if @image.persisted?
      redirect_to [:edit, :admin, @image]
    else
      redirect_to :back, alert: @image.errors.full_messages.join(", ")
    end
  end

  def fetch_selected_remote_images
    remote_image_ids = params[:image_ids]
    remote_image_ids.each do |image_id|
      Image.create_from_remote(image_id, current_user.id)
    end
    render json: {redirect_url: admin_images_path}
  end

  def image_params
    params.require(:image).permit(:title, :body, :link, :file, :recommend, :is_open, :main, {:parent_content_ids => []}, :user_id, :tag_list, :owner_name, :owner_url, :is_remix, :extra_copyright, :copyright_extra, :copyright, :author, :remix, :open)
  end
end
