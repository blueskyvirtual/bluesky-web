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
end
