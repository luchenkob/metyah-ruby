class Place < ApplicationRecord
  has_one :event, dependent: :destroy

  validates :tax_rate, :timezone, :currency, presence: true
  validates :tax_rate,
            numericality: {
              greater_than_or_equal_to: 0,
              less_than: 1,
            }

  TIMEZONES = [
    "Pacific Time (US & Canada)",
    "Mountain Time (US & Canada)",
    "Central Time (US & Canada)",
    "Eastern Time (US & Canada)",
    "Atlantic Time (Canada)"
  ]
  validates :timezone, :inclusion => { :in => Place::TIMEZONES }

  CURRENCIES = [
    "USD",
    "CAN"
  ]
  validates :currency, :inclusion => { :in => Place::CURRENCIES }
end
