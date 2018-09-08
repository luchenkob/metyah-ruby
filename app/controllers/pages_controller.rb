class PagesController < ApplicationController
  def root
    if current_user
      redirect_to '/user'
    elsif current_host
      redirect_to admin_path
    else
      redirect_to '/user'
    end

  end
end
