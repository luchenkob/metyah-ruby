class UserController < ApplicationController
  # All user controllers should inherit from this controller

  layout "user"

   # Refactor to handle admin/host/user authentication
   # => https://github.com/plataformatec/devise/wiki/How-to-Setup-Multiple-Devise-User-Models
   #    => May need to add sessions/registrations controllers
  before_action :authenticate_user!
end
