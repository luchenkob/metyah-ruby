class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users/1
  # GET /users/1.json
  def show
    redirect_to user_profile_path
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_profile_path, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render 'user/profile/profile' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      user_params_hash = params.require(:user).permit(
        :email, :first_name, :last_name, :birthdate, :gender,
        :career, :school, :location, :bio,
        :photo,
        :interests => []
      )

      if @user.present?
        user_params_hash.delete(:photo) unless user_params_hash[:photo].present?
      end


      user_params_hash[:birthdate] = DateTime.strptime(user_params_hash["birthdate"], "%m/%d/%Y %H:%M %p")
      user_params_hash[:interests] = user_params_hash[:interests].select { |interest| interest.present? }.join(',')

      user_params_hash
    end
end
