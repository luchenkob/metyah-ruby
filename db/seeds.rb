# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Place.create(
  name: "Calgary, AB, Canada",
  tax_rate: 0.05,
  timezone: "Mountain Time (US & Canada)",
  currency: "CAN",
  date_format: '%Y/%m/%d',
  time_format: '%I:%M %p',
)
