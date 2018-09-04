class User::PrivateMessage < ApplicationRecord
  belongs_to :sender, :class_name => "User"
  belongs_to :recipient, :class_name => "User"
  belongs_to :event

  validates :content, :recipient_id, :sender_id, :event_id, :message_intent, presence: true
  validates :content, length: { maximum: 250 }

  MESSAGE_INTENTS = [
    MESSAGE_INTENT_SOCIAL = "Social".freeze,
    MESSAGE_INTENT_PROFESSIONAL = "Professional".freeze,
    MESSAGE_INTENT_ROMANCE = "Romance".freeze,
  ].freeze
  validates :message_intent, :inclusion => { :in => User::PrivateMessage::MESSAGE_INTENTS }
end
