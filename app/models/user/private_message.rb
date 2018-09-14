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
  validate :message_intent_allowed
  serialize :message_intent

  default_scope { order(created_at: :desc) }

  def message_intent_allowed
    puts message_intent.inspect
    if message_intent.present? && (message_intent.split(',') - MESSAGE_INTENTS).size > 0
      errors.add(:message_intent, "is not valid")
    end
  end

  def message_intents

  end

  def self.threads_for(user, event = nil)
    query = where(recipient_id: user.id)
    if event.present?
      query = query.where(event_id: event.id)
    end

    query.reorder(sender_id: :asc, created_at: :desc).to_a.uniq(&:sender_id).sort_by{ |pm| pm.created_at }.reverse!
  end
end
