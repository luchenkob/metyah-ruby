class User::Events::CurrentController < UserController
  before_action :set_current_event

  def attendees
    @event_users = @current_event.event_users
  end

  def favorites
    @event_users = @current_event.event_users
  end

  def inbox
    @messages = User::PrivateMessage.all
    #@messages = User::PrivateMessage.where(recipient_id: current_user.id)
  end

  private
    def set_current_event
      @current_event = Event.last || Event.new(name: "No Current Event...")
    end
end
