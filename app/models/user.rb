class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  acts_as_voter
  acts_as_votable # Can block/favorite this

  has_uploadcare_file :photo

  has_many :profile_photos
  has_many :event_users, dependent: :destroy
  has_many :events, through: :event_users

  validates :email, :first_name, :last_name, :birthdate, :gender, :photo, presence: true

  validates :bio, length: { maximum: 150 }

  before_validation :standardize

  GENDER_MALE = "Male"
  GENDER_FEMALE = "Female"
  GENDERS = [GENDER_MALE, GENDER_FEMALE]
  validates :gender, :inclusion => { :in => User::GENDERS }

  after_save :find_create_profile_photo # update profile photo user_id

  def standardize
    #self.birthdate = DateTime.strptime(birthdate, "%m/%d/%Y %H:%M %p")
  end

  def find_create_profile_photo
    if photo.present?
      profile_picture = ProfilePhoto.find_or_create_by(url: self.photo.to_s)
      if !profile_picture.user_id.present?
        profile_picture.update(user_id: id) if id.present?
      end
    end
  end

  def age
    # Source: https://medium.com/@craigsheen/calculating-age-in-rails-9bb661f11303
    # May be slightly off based on timezone
    ((Time.current - birthdate.to_time) / 1.year.seconds).floor
  end

end
