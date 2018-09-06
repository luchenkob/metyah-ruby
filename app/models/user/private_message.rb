class User::PrivateMessage < ApplicationRecord
  belongs_to :sender, :class_name => "User"
  belongs_to :recipient, :class_name => "User"
  belongs_to :event

  serialize :message_intent

  validates :content, :recipient_id, :sender_id, :event_id, :message_intent, presence: true
  validates :content, length: { maximum: 250 }

  MESSAGE_INTENTS = [
    MESSAGE_INTENT_SOCIAL = "Social".freeze,
    MESSAGE_INTENT_PROFESSIONAL = "Professional".freeze,
    MESSAGE_INTENT_ROMANCE = "Romance".freeze,
  ].freeze
  validate :message_intent_allowed

  default_scope { order(created_at: :desc) }

  def message_intent_allowed
    puts message_intent.inspect
    if message_intent.present? && (message_intent.split(',') - MESSAGE_INTENTS).size > 0
      errors.add(:message_intent, "is not valid")
    end
  end
end
