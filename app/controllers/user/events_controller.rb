class User::EventsController < UserController
  before_action :set_event, only: [:show]

  def index
    redirect_to my_events_user_events_path
  end

  def show
  end

  def my_events
    @events = Event.all
  end

  def join
  end

  def search
    @events = Event.all
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

end
