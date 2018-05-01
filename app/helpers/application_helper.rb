# frozen_string_literal: true

module ApplicationHelper
  # Format the date display for a record
  #
  # obj can either be an ActiveRecord result with associated field
  # or a Time object.
  #
  def date_display(obj, field = nil)
    return if obj.blank?
    format = '%m/%d/%Y'

    if obj.is_a? ActiveRecord::Base
      obj.send(field.to_sym).strftime(format)
    else
      obj.strftime(format)
    end
  end

  # Format the date and time display for a record
  #
  # obj can either be an ActiveRecord result with associated field
  # or a Time object.
  #
  def datetime_display(obj, field = nil)
    return if obj.blank?
    format = '%m/%d/%Y %H:%M %Z'

    if obj.is_a? ActiveRecord::Base
      obj.send(field.to_sym).strftime(format)
    else
      obj.strftime(format)
    end
  end

  # Attempt to find time a time at a geocoded object or convert it to
  # the appropriate timezone.
  #
  # If timezone was unable to be determined from lat/long it will return in UTC.
  #
  # Ignoring DST is set true by default, this avoids confusion with flight
  # schedules and adjusts the time appropriately whether DST is in effect
  # or not. Set false to return time adjusted for DST.
  #
  # Returns a Time object for further formatting
  #
  def find_time(geo_obj, time, _ignore_dst = false)
    tz = find_timezone(geo_obj)
    time.in_time_zone(tz)

    # (time.dst? ? time - 1.hour : time) if ignore_dst
  end

  # Attempt to find the Timezone at a geocoded object
  #
  # Returns a Timezone object
  #
  def find_timezone(geo_obj)
    tz = TimezoneFinder.create
    tz = tz.timezone_at(lng: geo_obj.longitude, lat: geo_obj.latitude)

    tz = 'UTC' if tz == 'uninhabited'
    tz
  end

  # Format the time display for a record
  #
  # obj can either be an ActiveRecord result with associated field
  # or a Time object.
  #
  def time_display(obj, field = nil)
    return if obj.blank?
    format = '%H:%M %Z'

    if obj.is_a? ActiveRecord::Base
      obj.send(field.to_sym).strftime(format)
    else
      obj.strftime(format)
    end
  end
end
