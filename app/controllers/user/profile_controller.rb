class User::ProfileController < UserController
  def profile
    @user = current_user
  end

  def settings
  end

  def messages
  end
end
