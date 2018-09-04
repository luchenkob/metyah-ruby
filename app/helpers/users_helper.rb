module UsersHelper
  def photo_url_for(user, dimensions, filename)
    "#{user.photo}-/scale_crop/#{dimensions}/center/#{filename}"
  end

  def profile_photo_url_for(user)
    photo_url_for(user, '350x350', 'profile.jpg')
  end

  def thumb_photo_url_for(user)
    photo_url_for(user, '150x150', 'thumb.jpg')
  end
end
