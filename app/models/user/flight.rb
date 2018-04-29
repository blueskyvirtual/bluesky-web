# frozen_string_literal: true

class User::Flight < ApplicationRecord
  # Audit
  audited

  # ActiveRecord associations
  belongs_to :user

  belongs_to :airline_flight,
             class_name: 'Airline::Flight', inverse_of: :user_flights

  belongs_to :aircraft_type,
             class_name: 'Aircraft::Type', inverse_of: :user_flights

  belongs_to :network, optional: true

  # ActiveRecord callbacks
  before_validation :calculate_duration

  # ActiveRecord validations
  validates :user,           presence: true, allow_blank: false
  validates :airline_flight, presence: true, allow_blank: false
  validates :aircraft_type,  presence: true, allow_blank: false
  validates :time_out,       presence: true, allow_blank: false
  validates :time_off,       presence: true, allow_blank: false
  validates :time_on,        presence: true, allow_blank: false
  validates :time_in,        presence: true, allow_blank: false
  validates :route,          presence: true, allow_blank: false

  validates :duration, presence: true, numericality: { greater_than: 0 }

  validate :validate_times
  validate :validate_time_off
  validate :validate_time_on
  validate :validate_time_in

  # Scopes
  default_scope { where(approved: true).order(time_in: :desc) }
  scope :online, -> { where.not(network: nil) }

  private

  def calculate_duration
    return if time_out.blank? || time_in.blank?
    self.duration = TimeDifference.between(time_out, time_in).in_hours
  end

  # Validates the timestamp values are not in the future
  #
  def validate_times
    %i[time_out time_off time_on time_in].each do |time|
      next if send(time).blank? || send(time) < Time.now.utc
      errors[time] << 'cannot be in the future'
    end
  end

  # Validates the in time cannot be before the on time
  #
  def validate_time_in
    return unless time_on.present? && time_in.present?
    return unless time_on > time_in
    errors[:time_in] << 'cannot be before on'
  end

  # Validates the off time cannot be before the out time
  #
  def validate_time_off
    return unless time_out.present? && time_off.present?
    return unless time_out > time_off
    errors[:time_off] << 'cannot be before out'
  end

  # Validates the off time cannot be before the out time
  #
  def validate_time_on
    return unless time_off.present? && time_on.present?
    return unless time_off > time_on
    errors[:time_on] << 'cannot be before off'
  end
end
