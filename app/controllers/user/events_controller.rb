class User::EventsController < UserController
  before_action :set_event, only: [:show, :modal]

  def index
    redirect_to my_events_user_events_path
  end

  def show
  end

  def my_events
    @events = current_user.events
  end

  def join
    @event = Event.find_by_code(params[:code])
    if @event.present? && current_user.present?
      EventUser.create(event_id: @event.id, user_id: current_user.id)
      flash[:success] = "You have joined this event"
      redirect_to my_events_user_events_path
    end
  end

  def search
    @events = Event.all
  end

  def modal
    respond_to do |format|
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

end
