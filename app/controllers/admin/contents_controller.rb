class Admin::ContentsController < AdminController
  def index
    @contents = Content.where(is_remix: true)
                       .in_title(params[:title])
                       .in_body(params[:body])
                       .in_owner(params[:owner_name])
                       .in_author(params[:author])
                       .in_remix(params[:remix])
                       .in_open(params[:open])
                       .in_main(params[:main])
                       .in_copyright(params[:copyright])
                       .order('created_at DESC').page(params[:page]).per(10)
  end
  def search
    @contents = Content.where(is_open: true).in_query(params[:q]).in_copyright(params[:copyright]).page(params[:page]).per(16)
  end
end
