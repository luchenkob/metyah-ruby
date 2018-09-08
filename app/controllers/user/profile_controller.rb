class User::ProfileController < UserController
  def profile
    @user = current_user
  end

  def settings
  end

  def messages
    @messages = User::PrivateMessage
    .where(recipient_id: current_user.id)
    .or(
      User::PrivateMessage
      .where(sender_id: current_user.id)
    ).includes(:sender, :event, event: :place)
  end
end
