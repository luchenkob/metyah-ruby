class User::Events::CurrentController < UserController
  before_action :set_current_event

  def attendees
    @event_users = @current_event.event_users
  end

  def favorites
    @event_users = @current_event.event_users
  end

  def inbox
    @messages = User::PrivateMessage.where(recipient_id: current_user.id).or(User::PrivateMessage.where(sender_id: current_user.id))
  end

  def message_send_modal
    @send_to = User.find(params[:sent_to_id])

    respond_to do |format|
      format.js
    end
  end

  def message_reply_modal
    @reply_to = User.find(params[:reply_to_id])

    respond_to do |format|
      format.js
    end
  end

  private
    def set_current_event
      @current_event = Event.find(params[:id]) || Event.last || Event.new(name: "No Current Event...")
    end
end
