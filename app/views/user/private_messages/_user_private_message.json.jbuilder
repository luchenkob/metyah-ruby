json.extract! user_private_message, :id, :content, :sender_id, :recipient_id, :created_at, :updated_at
json.url user_private_message_url(user_private_message, format: :json)
