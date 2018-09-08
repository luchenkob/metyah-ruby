class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?


  layout :layout_by_resource

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


  private

  def layout_by_resource
    puts controller_path.inspect
    if controller_path.include?("user")
      "user"
    elsif controller_path.include?("admin") || controller_path.include?("host")
      "admin"
    elsif controller_path.include?("devise")
      case resource_name
      when :host
        "admin"
      when :user
        "user"
      else
        "application"
      end
    else
      "application"
    end
  end
end
