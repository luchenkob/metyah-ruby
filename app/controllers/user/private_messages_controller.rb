class User::PrivateMessagesController < ApplicationController
  before_action :set_user_private_message, only: [:show, :edit, :update, :destroy]

  # GET /user/private_messages
  # GET /user/private_messages.json
  def index
    @user_private_messages = User::PrivateMessage.all
  end

  # GET /user/private_messages/1
  # GET /user/private_messages/1.json
  def show
  end

  # GET /user/private_messages/new
  def new
    @user_private_message = User::PrivateMessage.new
  end

  # GET /user/private_messages/1/edit
  def edit
  end

  # POST /user/private_messages
  # POST /user/private_messages.json
  def create
    @user_private_message = User::PrivateMessage.new(user_private_message_params)

    respond_to do |format|
      if @user_private_message.save
        format.html { redirect_to @user_private_message, notice: 'Private message was successfully created.' }
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
    @user_private_message.destroy
    respond_to do |format|
      format.html { redirect_to user_private_messages_url, notice: 'Private message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_private_message
      @user_private_message = User::PrivateMessage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_private_message_params
      params.require(:user_private_message).permit(:content, :sender_id, :recipient_id)
    end
end
