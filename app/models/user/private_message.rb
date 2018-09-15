class User::PrivateMessage < ApplicationRecord
  belongs_to :sender, :class_name => "User"
  belongs_to :recipient, :class_name => "User"
  belongs_to :event

  validates :content, :recipient_id, :sender_id, :event_id, presence: true
  validates :message_intent, presence: true, if: :message_intent_required?
  validates :content, length: { maximum: 250 }

  MESSAGE_INTENTS = [
    MESSAGE_INTENT_SOCIAL = "Social".freeze,
    MESSAGE_INTENT_PROFESSIONAL = "Professional".freeze,
    MESSAGE_INTENT_ROMANCE = "Romance".freeze,
  ].freeze
  validate :message_intent_required?
  validate :message_intent_valid
  serialize :message_intent

  default_scope { order(created_at: :desc) }

  def message_intent_required?
    User::PrivateMessage.where(recipient_id: recipient_id, sender_id: recipient_id)
    .where.not(message_intent: [nil, ""])
    .present?
  end

  def message_intent_valid
    puts message_intent.inspect
    if message_intent.present? && (message_intent.split(',') - MESSAGE_INTENTS).size > 0
      errors.add(:message_intent, "is not valid")
    end
  end

  def self.threads_for(user_id, event_id = nil)
    query = where(recipient_id: user_id)
    if event_id.present?
      query = query.where(event_id: event_id)
    end

    query.reorder(sender_id: :asc, created_at: :desc).to_a.uniq(&:sender_id).sort_by{ |pm| pm.created_at }.reverse!
  end

  def self.messages_for(user_id, sender_id, event_id)
    query = where(recipient_id: user_id, sender_id: sender_id)

    query = query.where(event_id: event_id) if event_id.present?

    query.reorder(created_at: :desc)
  end

  def self.unread_messags_for(user_id, event_id = nil, sender_id = nil)
    query = where(recipient_id: user_id, message_read: false)

    query = query.where(sender_id: sender_id) if sender_id.present?
    query = query.where(event_id: event_id) if event_id.present?

    query.reorder(created_at: :desc)
  end
end
