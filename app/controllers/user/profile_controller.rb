class User::ProfileController < UserController
  def profile
    @user = current_user
  end

  def settings
  end

  def messages
    # @messages = User::PrivateMessage
    # .where(recipient_id: current_user.id)
    # .where.not(sender_id: current_user.blocked_user_ids)
    # .or(
    #   User::PrivateMessage
    #   .where(sender_id: current_user.id)
    #   .where.not(sender_id: current_user.blocked_user_ids)
    # ).includes(:sender, :event, event: :place)

    @messages = User::PrivateMessage.threads_for(current_user.id)
  end
end
