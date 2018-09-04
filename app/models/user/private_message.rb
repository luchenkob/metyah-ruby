class User::PrivateMessage < ApplicationRecord
  belongs_to :sender, :class_name => "User"
  belongs_to :recipient, :class_name => "User"

  validates :content, :recipient_id, :sender_id, presence: true
  validates :content, length: { maximum: 250 }
end
