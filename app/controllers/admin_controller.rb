class AdminController < ApplicationController

  before_filter :verify_admin
  load_and_authorize_resource except: [:create]

  private

  def verify_admin
    if not (current_user && current_user.role != 'guest')
      redirect_to root_url
    end
  end
end