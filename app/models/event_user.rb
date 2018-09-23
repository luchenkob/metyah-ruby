class EventUser < ApplicationRecord
  belongs_to :event
  belongs_to :user

  validates :user, uniqueness: { scope: :event, message: "is already part of this event" }

  def user_age_zoned
    ((Time.current.in_time_zone(event.place.timezone) - user.birthdate.to_time) / 1.year.seconds).floor
  end
end
