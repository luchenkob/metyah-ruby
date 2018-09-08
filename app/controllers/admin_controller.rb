class AdminController < ApplicationController
  # All admin controllers should inherit from this controller

  layout "admin"

  before_action :authenticate_host!

end
