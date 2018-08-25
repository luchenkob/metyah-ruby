require 'faker'
FactoryBot.define do
   factory :user do
     email { Faker::Internet.email }
     password { "PASSWORD" }
     first_name { Faker::Name.first_name }
     last_name { Faker::Name.last_name }
     birthdate { Faker::Date.between(Date.today - 55.years, Date.today - 19.years) }
     gender { User::GENDERS.sample }
     career { Faker::Job.title }
     school { Faker::Educator.university }
     location { "#{Faker::Address.city}, #{Faker::Address.state}"}
     bio { Faker::Lorem.paragraph_by_chars([50,100,140].sample, false) }
   end
end