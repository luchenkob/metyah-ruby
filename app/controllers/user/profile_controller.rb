class User::ProfileController < UserController
  def profile
    @user = current_user
  end

  def settings
  end

  def messages
    @messages = User::PrivateMessage.threads_for(current_user.id)
  end
end
