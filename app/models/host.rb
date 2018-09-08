class Host < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable, # Registration not allowed
         :recoverable, :rememberable, :validatable

  has_many :events, dependent: :destroy
end
