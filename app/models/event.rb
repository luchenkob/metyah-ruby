class Event < ApplicationRecord
  after_initialize :set_default_values
  before_validation :set_code, unless: Proc.new { |event| event.code.present? }
  before_save :split_start_end_at

  has_many :event_users, dependent: :destroy
  has_many :users, through: :event_users

  belongs_to :host
  belongs_to :place

  validates :host, presence: true, on: :create
  validates :name, :address, :description, presence: true
  validates :code, presence: true, uniqueness: true
  validates :start_end_at, :place_id, presence: true
  validates :description, length: { minimum: 2, maximum: 500 }
  validates :ticket_purchase_url, url: { allow_blank: true }
  validates :contact_info, length: { minimum: 10, maximum: 250, :allow_blank => true }
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

  scope :active, -> { where(event_status: EVENT_STATUS_ACTIVE) }
  scope :inactive, -> { where(event_status: EVENT_STATUS_INACTIVE) }

  def active?
    event_status == EVENT_STATUS_ACTIVE
  end

  def self.past
    active.where(end_at: Time.at(0)..Time.current)
  end

  def self.current
    active.
    where(
      start_at: Time.at(0)..Time.current,
      end_at: Time.current..DateTime::Infinity.new,
    )
  end

  def self.upcoming
    active.where(start_at: Time.current..DateTime::Infinity.new)
  end

  def tense
    if Event.past.include?(self)
      "Past"
    elsif Event.current.include?(self)
      "Current"
    elsif Event.upcoming.include?(self)
      "Upcoming"
    else
      "Pending"
    end
  end

  def self.find_by_code(entered_code)
    find_by(code: entered_code)
  end

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
    self.start_at, self.end_at = self
    .start_end_at
    .split(" - ")
    .map do |date|
      datetime = DateTime.strptime("#{date} #{place.timezone}", "%m/%d/%Y %H:%M %p %z").to_time
      datetime_formatted = datetime.strftime("%Y-%m-%d %H:%M %p")
      ActiveSupport::TimeZone[place.timezone].parse(datetime_formatted)
    end
  end

  def set_code
    # Use devise for
    self.code = generate_code
  end

  def self.code_digits_required(num_events = 0)
    # Require enough digits to ensure very low probability of collision
    if num_events == 0
      num_events = Event.all.size
    end
    required_solution_space = 2 * num_events + 1

    required = Math.log(required_solution_space,CODE_CHARACTERS.size).ceil + 3
    required
  end

  def generate_code
    existing_codes = Event.all.pluck(:code)

    no_code = nil

    10.times do
      new_code = Event.code_digits_required.times.map { CODE_CHARACTERS.sample  }.join("")

      return new_code unless existing_codes.include?(new_code)
    end

    puts "NO unique code could be generated"

    no_code
  end

  def display_profiles_starts_at
    start_at + display_profiles_after_minutes.minutes
  end

  def display_profiles_ends_at
    display_profiles_starts_at + display_profiles_for_minutes.minutes
  end

  def display_profiles?
    display_profiles_starts_at <= Time.current && Time.current <= display_profiles_ends_at
  end

  def allow_messaging_starts_at
    end_at + allow_messaging_after_minutes.minutes
  end

  def allow_messaging_ends_at
    allow_messaging_starts_at + allow_messaging_for_minutes.minutes
  end

  def allow_messaging?
    allow_messaging_starts_at <= Time.current && Time.current <= allow_messaging_ends_at
  end

  def allow_messaging_status_message
    if Time.current < allow_messaging_starts_at
      "Messaging will be allowed #{allow_messaging_starts_at_zoned_datetime}"
    elsif Time.current > allow_messaging_ends_at
      "Messaging expired #{allow_messaging_ends_at_zoned_datetime}"
    else
      "Messaging is allowed"
    end
  end

  def current_time
    Time.current
  end


  zoned_methods = [
    :start_at, :end_at,
    :display_profiles_starts_at, :display_profiles_ends_at,
    :allow_messaging_starts_at, :allow_messaging_ends_at,
    # temp Methods
    :current_time
  ]
  zoned_methods.each do |zone_method|
    # Defines the following instance helper methods
    #   start_at_zoned, start_at_zoned_date, start_at_zoned_time, start_at_zoned_datetime
    #   end_at_zoned, end_at_zoned_date, end_at_zoned_time, end_at_zoned_datetime
    #   display_profiles_starts_at_zoned, display_profiles_starts_at_zoned_date,
    #     display_profiles_starts_at_zoned_time, display_profiles_starts_at_zoned_datetime
    #   display_profiles_ends_at_zoned, display_profiles_ends_at_zoned_date,
    #     display_profiles_ends_at_zoned_time, display_profiles_ends_at_zoned_datetime
    #   allow_messaging_starts_at_zone, allow_messaging_starts_at_zoned_date,
    #     allow_messaging_starts_at_zoned_time, allow_messaging_starts_at_zoned_datetime
    #   allow_messaging_ends_at_zoned, allow_messaging_ends_at_zoned_date,
    #     allow_messaging_ends_at_zoned_time, allow_messaging_ends_at_zoned_datetime
    # Note: Refactor this to 4 view helper methods if more methods are added

    define_method("#{zone_method}_zoned") do
      send(zone_method).in_time_zone(place.timezone)
    end

    define_method("#{zone_method}_zoned_date") do
      send(zone_method).in_time_zone(place.timezone).strftime("#{place.date_format}")
    end

    define_method("#{zone_method}_zoned_time") do
      send(zone_method).in_time_zone(place.timezone).strftime("#{place.time_format}")
    end

    define_method("#{zone_method}_zoned_datetime") do
      send(zone_method).in_time_zone(place.timezone).strftime("#{place.date_format} #{place.time_format}")
    end
  end
end
