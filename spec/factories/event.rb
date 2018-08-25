require 'faker'
FactoryBot.define do
  factory :event do
    place
    start_at { nil } # Autofilled via start_end_at
    end_at { nil } # Autofilled via start_end_at
    address { "#{Faker::Address.full_address}"}
    description { Faker::Lorem.paragraph_by_chars([50,100,140].sample, false) }
    # code { } # Not needed because it's autogenerated
    event_status { Event::EVENT_STATUSES.sample }
    event_type { Event::EVENT_TYPES.sample }

    display_profiles_after_minutes { Faker::Number.between(1, 5) * 15 }
    display_profiles_for_minutes   { Faker::Number.between(1, 5) * 150 }
    allow_messaging_after_minutes  { Faker::Number.between(1, 5) * 15 }
    allow_messaging_for_minutes    { Faker::Number.between(1, 5) * 150 }

    sequence(:name) { |n| "Autogen Event ##{n}" }

    upcoming_event

    trait :past_event do
      start_end_at do
        start_at, end_at = [
          Faker::Time.backward(30),Faker::Time.backward(30)
        ]
        .map { |datetime| datetime.in_time_zone(place.timezone).strftime("%m/%d/%Y %H:%M %p") }
        .sort

        "#{start_at} - #{end_at}"
      end
    end

    trait :random_event do
      start_end_at do
        start_at, end_at = [Faker::Time.backward(30), Faker::Time.forward(30)]
        .map { |datetime| datetime.in_time_zone(place.timezone).strftime("%m/%d/%Y %H:%M %p") }

        "#{start_at} - #{end_at}"
      end
    end

    trait :current_event do
      start_end_at do
        start_at, end_at = [Faker::Time.backward(1), Faker::Time.forward(1)]
        .map { |datetime| datetime.in_time_zone(place.timezone).strftime("%m/%d/%Y %H:%M %p") }

        "#{start_at} - #{end_at}"
      end
    end

    trait :upcoming_event do
      start_end_at do
        start_at, end_at = [Faker::Time.forward(30), Faker::Time.forward(30)]
        .map { |datetime| datetime.in_time_zone(place.timezone).strftime("%m/%d/%Y %H:%M %p") }
        .sort

        "#{start_at} - #{end_at}"
      end
    end
  end
end
