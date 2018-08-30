module UsersHelper
  def profile_photo_url_for(user)
    # May be best moved to model
    "#{@user.photo}-/scale_crop/350x350/center/profile.jpg"
  end
end
