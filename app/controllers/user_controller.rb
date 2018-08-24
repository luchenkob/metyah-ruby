class UserController < ApplicationController
  # All user controllers should inherit from this controller
  before_action :authenticate_user!

  layout "user"
end
