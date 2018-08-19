class Event < ApplicationRecord
  after_initialize :set_default_values
  before_validation :set_code, unless: Proc.new { |event| event.code.present? }
  before_save :split_start_end_at

  belongs_to :place

  validates :code, presence: true, uniqueness: true
  validates :start_end_at, :place_id, presence: true
  validates :display_profiles_after_minutes,
            :display_profiles_for_minutes,
            :allow_messaging_after_minutes,
            :allow_messaging_for_minutes,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0,
            }

  CODE_CHARACTERS = "2456789BCDFGHJKLMNPRSTVWXZ".split("").freeze

  EVENT_STATUS_INACTIVE = "Inactive".freeze
  EVENT_STATUS_ACTIVE = "Active".freeze
  EVENT_STATUSES = [EVENT_STATUS_INACTIVE, EVENT_STATUS_ACTIVE].freeze
  validates :event_status, :inclusion => { :in => Event::EVENT_STATUSES }

  EVENT_TYPE_SPEED_DATING = "Speed Dating".freeze
  EVENT_TYPE_MIXER = "Mixer".freeze
  EVENT_TYPE_NETWORKING = "Networking".freeze
  EVENT_TYPE_OTHER = "Other".freeze
  EVENT_TYPES = [EVENT_TYPE_SPEED_DATING, EVENT_TYPE_MIXER, EVENT_TYPE_NETWORKING, EVENT_TYPE_OTHER].freeze
  validates :event_type, :inclusion => { :in => Event::EVENT_TYPES }

  def set_default_values
    # Defaults are not intended to be valid, only sensible.
    # With defaults Model.create should always fail.
    self.name ||= ""
    self.description ||= ""
    self.code ||= ""
    self.event_status ||= ""
    self.event_type ||= ""
    self.display_profiles_after_minutes ||=  30 # Temp
    self.display_profiles_for_minutes   ||= 300 # Temp
    self.allow_messaging_after_minutes  ||=  30 # Temp
    self.allow_messaging_for_minutes    ||= 300 # Temp
  end

  def standardize
  end

  def split_start_end_at
    # Expected format of start_end_at: 08/18/2018 3:56 PM - 08/18/2018 3:56 PM
    # - Todo: Add timezone handling
    puts "start_end_at: #{start_end_at}"
    self.start_at, self.end_at = self.start_end_at.split(" - ").map { |date| DateTime.strptime(date, "%m/%d/%Y %H:%M %p") }

  end

  def set_code
    # Use devise for
    self.code = generate_code
  end

  def self.code_digits_required(num_events = 0)
    # Require enough digits to ensure less than 50% probability of collision
    num_events = num_events || Event.all.size
    required_solution_space = 2 * num_events + 1

    (required_solution_space ** (1.0 / CODE_CHARACTERS.size.to_f)).ceil
  end

  def generate_code
    existing_codes = Event.all.pluck(:code)

    no_code = nil

    10.times do
      new_code = Event.code_digits_required.times.map { CODE_CHARACTERS.sample  }.join("")

      return new_code unless existing_codes.include?(new_code)
    end

    no_code
  end

  def display_profiles_starts_at
    start_at + display_profiles_after_minutes.minutes
  end

  def display_profiles_ends_at
    display_profiles_for_minutes + display_profiles_for_minutes.minutes
  end

  def display_profiles?
    display_profiles_starts_at <= Time.current && Time.current <= display_profiles_ends_at
  end

  def allow_messaging_starts_at
    end_at + allow_messaging_after_minutes.minutes
  end

  def allow_messaging_ends_at
    allow_messaging_starts_at + display_profiles_for_minutes.minutes
  end

  def allow_messaging?
    allow_messaging_starts_at <= Time.current && Time.current <= allow_messaging_ends_at
  end

end
