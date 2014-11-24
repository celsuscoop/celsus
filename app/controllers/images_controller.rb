#encoding: utf-8

class ImagesController < ApplicationController

  def index
    @main_images = Image.where(main: true).where(is_open: true).order("created_at DESC").limit(5)
    @images = Image.where(is_open: true).order("created_at DESC").page(params[:page]).per(8)
  end

  def new
    @image = Image.new
    @image.is_remix = true
    authorize! :create, @image

  end

  def create
    @image = Image.new image_params
    @image.user = current_user
    if @image.save
      redirect_to root_url, notice: '이미지가 성공적으로 등록되었습니다. 관리자 승인 후 노출됩니다.'
    else
      render 'new'
    end
  end

  def show
    @image = Image.find(params[:id])
    @image.view = @image.view + 1
    @image.save

    @author_images = Image.where(user_id: @image.user_id).where(is_open: true)
    @friendly_images = @image.friendly_images

    @warning = Warning.new
    @content = @image
  end

  def download
    @image = Image.find(params[:image_id])
    authorize! :download, @image
    @image.increase_download_count(current_user)
    redirect_to @image.download_url
  end
  def image_params
    params.require(:image).permit(:title, :body, :link, :file, :recommend, {:parent_content_ids => []}, :user_id, :tag_list, :is_remix, :owner_name, :owner_url, :extra_copyright, :copyright_extra, :copyright)
  end
end