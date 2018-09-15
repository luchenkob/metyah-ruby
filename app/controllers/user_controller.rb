class UserController < ApplicationController
  # All user controllers should inherit from this controller

  layout "user"

   # Refactor to handle admin/host/user authentication
   # => https://github.com/plataformatec/devise/wiki/How-to-Setup-Multiple-Devise-User-Models
   #    => May need to add sessions/registrations controllers
  before_action :authenticate_user!

  before_action :set_current_event

  def set_current_event
    @current_event = Event.find_by(id: params[:id].to_i) || current_user.events.current.reorder(:start_at).first
  end
end
