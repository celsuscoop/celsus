#encoding: utf-8
class PagesController < ApplicationController
  def home
    @images  = Image.where(is_open: true).popular
    @videos  = Video.where(is_open: true).popular
    @audios  = Audio.where(is_open: true).popular
    @remixes = Content.where(is_remix: true).where(is_open: true).popular
  end
  def temporary
    render layout: false
  end

  def master_login

  end


  def change_user_session
    unless Rails.env.production?
      user = User.find(params[:page_id])
      sign_in(user)
      redirect_to :back
    else
      raise 'nonono'
    end
  end
end
