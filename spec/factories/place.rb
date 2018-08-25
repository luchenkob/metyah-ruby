require 'faker'
FactoryBot.define do
   factory :place do
     name { "#{Faker::Address.city}, #{Faker::Address.state_abbr}, US" }
     timezone { Place::TIMEZONES.sample }
     tax_rate { Faker::Number.decimal(0, 2) }
     currency { ["CAN", "USD"].sample }
     date_format { "%m/%d/%Y" }
     time_format { "%I:%M %p" }
   end
end
