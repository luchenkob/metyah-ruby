class User::PrivateMessagesController < UserController
  before_action :set_user_private_message, only: [:show, :edit, :update, :destroy]
  after_action :mark_messages_as_read, only: [:index]

  def index
    @sender = User.find_by(id: params[:sender_id])
    @event = Event.find_by(id: params[:event_id])

    @user_private_messages = User::PrivateMessage
    .messages_for(current_user.id, params[:sender_id], params[:event_id]).reorder(created_at: :asc)
  end

  # POST /user/private_messages
  # POST /user/private_messages.json
  def create
    @user_private_message = User::PrivateMessage.new(user_private_message_params)

    respond_to do |format|
      if @user_private_message.save
        format.html { redirect_to inbox_user_current_event_path(id: @user_private_message.event_id), notice: 'Private message was successfully created.' }
        format.json { render :show, status: :created, location: @user_private_message }
      else
        format.html { render :new }
        format.json { render json: @user_private_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user/private_messages/1
  # PATCH/PUT /user/private_messages/1.json
  def update
    respond_to do |format|
      if @user_private_message.update(user_private_message_params)
        format.html { redirect_to @user_private_message, notice: 'Private message was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_private_message }
      else
        format.html { render :edit }
        format.json { render json: @user_private_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user/private_messages/1
  # DELETE /user/private_messages/1.json
  def destroy
    # @user_private_message.destroy
    # respond_to do |format|
    #   format.html { redirect_to user_private_messages_url, notice: 'Private message was successfully destroyed.' }
    #   format.json { head :no_content }
    # end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_private_message
      @user_private_message = User::PrivateMessage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_private_message_params
      pm_hash = params.require(:user_private_message).permit(
        :content, :sender_id, :recipient_id, :event_id, message_intent: [])
      pm_hash[:message_intent] = pm_hash[:message_intent].to_a.select { |mi| mi.present? }.join(',')
      if pm_hash[:message_intent].blank?
        pm_hash[:message_intent] = User::PrivateMessage.where(
          sender_id: pm_hash[:sender_id],
          recipient_id: pm_hash[:recipient_id],
        ).first&.message_intent
      end

      pm_hash
    end

    def mark_messages_as_read
      User::PrivateMessage
      .unread_messages_for(current_user.id, params[:event_id], params[:sender_id])
      .update_all(message_read: true)
    end
end
