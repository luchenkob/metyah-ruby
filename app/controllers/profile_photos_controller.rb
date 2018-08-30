class ProfilePhotosController < ApplicationController
  before_action :set_profile_photo, only: [:show, :edit, :update, :destroy]

  # POST /profile_photos
  # POST /profile_photos.json
  def create
    @profile_photo = ProfilePhoto.new(profile_photo_params)

    respond_to do |format|
      if @profile_photo.save
        format.js
      else
        format.js
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile_photo
      @profile_photo = ProfilePhoto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def profile_photo_params
      params.require(:profile_photo).permit(:url, :user_id)
    end
end
