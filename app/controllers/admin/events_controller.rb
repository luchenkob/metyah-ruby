class Admin::EventsController < AdminController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :redirect_unless_event_host, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    if current_host.admin?
      @events = Event.all
    else
      @events = Event.where(host_id: current_host.id)
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    puts event_params.inspect
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to [:admin, @event], notice: 'Event was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to [:admin, @event], notice: 'Event was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to admin_events_url, notice: 'Event was successfully destroyed.' }
    end
  end

  protected

    def redirect_unless_event_host
      if !(current_user == @event.host? ||  current_user.admin?)
        redirect_to admin_events_path
      end
    end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(
        :place_id, :host_id,
        :start_end_at, :name, :address, :description, :code, :event_status, :event_type,
        :ticket_purchase_url, :contact_info,
        :display_profiles_after_minutes, :display_profiles_for_minutes,
        :allow_messaging_after_minutes, :allow_messaging_for_minutes
      )
    end
end
