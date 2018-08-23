class User::Events::CurrentController < UserController
  before_action :set_current_event

  def attendees
  end

  def favorites
  end

  def inbox
  end

  private
    def set_current_event
      @current_event = Event.last || Event.new(name: "No Current Event...")
    end
end
