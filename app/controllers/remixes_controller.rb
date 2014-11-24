#encoding: utf-8

class RemixesController < ApplicationController
  def index
    @main_remixes = Content.where(is_remix: true).where(main: true).where(is_open: true).order("created_at DESC").limit(5)
    @remixes = Content.where(is_remix: true).where(is_open: true).order("created_at DESC").page(params[:page]).per(8)
  end
end