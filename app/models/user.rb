class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_uploadcare_file :photo

  has_many :event_users, dependent: :destroy
  has_many :events, through: :event_users

  validates :email, :first_name, :last_name, :birthdate, :gender, presence: true

  validates :bio, length: { maximum: 150 }

  before_validation :standardize

  GENDER_MALE = "Male"
  GENDER_FEMALE = "Female"
  GENDERS = [GENDER_MALE, GENDER_FEMALE]
  validates :gender, :inclusion => { :in => User::GENDERS }

  def standardize
    #self.birthdate = DateTime.strptime(birthdate, "%m/%d/%Y %H:%M %p")
  end

  def age
    # Source: https://medium.com/@craigsheen/calculating-age-in-rails-9bb661f11303
    # May be slightly off based on timezone
    ((Time.current - birthdate.to_time) / 1.year.seconds).floor
  end

end
