class User::Events::CurrentController < UserController
  before_action :redirect_unless_current_event

  def attendees
    @event_users = @current_event.event_users
  end

  def favorites
    @favorite_ids = current_user
    .votes # Favorites/blocks
    .up # Favorites
    .for_type(User) # Users only
    .pluck(:votable_id) # Get list of user ids

    @event_users = EventUser.where(event_id: @current_event.id, user_id: @favorite_ids)
  end

  def inbox
    @messages = User::PrivateMessage
    .where(recipient_id: current_user.id, event_id: @current_event.id)
    .where.not(sender_id: current_user.blocked_user_ids)
    .or(
      User::PrivateMessage
      .where(sender_id: current_user.id, event_id: @current_event.id)
      .where.not(sender_id: current_user.blocked_user_ids)
    ).includes(:sender, :event, event: :place)
  end

  def message_modal
    @send_to = User.find(params[:send_to_id])

    respond_to do |format|
      format.js
    end
  end

  private

    def redirect_unless_current_event
      if @current_event.nil?
        redirect_to root_path
      end
    end
end
