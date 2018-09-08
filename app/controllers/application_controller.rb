class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :first_name, :last_name, :birthdate, :gender, :photo])
  end

  def authenticate_admin!
    authenticate_host!
    if !current_host.admin?
      flash[:danger] = "You do not have permission to do that"
      redirect_to admin_path
    end
  end
end
