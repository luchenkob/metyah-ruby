# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "Seeding Places"
Place.create(
  name: "Calgary, AB, Canada",
  tax_rate: 0.05,
  timezone: "Mountain Time (US & Canada)",
  currency: "CAN",
  date_format: '%m/%d/%Y',
  time_format: '%I:%M %p',
) unless Place.find_by(name: "Calgary, AB, Canada").present?

puts "Seeding Events"

events = 2.times.map  { FactoryBot.create(:event, :current_event) }
events += 5.times.map  { FactoryBot.create(:event, :past_event) }
events += 5.times.map  { FactoryBot.create(:event, :upcoming_event) }

puts "Seeding Event Users"

events.each do |event|
  FactoryBot.create(:event_user, event_id: event.id)
end