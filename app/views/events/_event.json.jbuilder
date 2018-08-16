json.extract! event, :id, :start_at, :end_at, :name, :address, :description, :code, :event_status, :event_type, :display_profiles_after_minutes, :display_profiles_for_minutes, :allow_messaging_after_minutes, :allow_messaging_for_minutes, :created_at, :updated_at
json.url event_url(event, format: :json)
