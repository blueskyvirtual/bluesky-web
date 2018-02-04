# frozen_string_literal: true

class Airline::Fleet < ApplicationRecord
  # Audits
  audited

  # ActiveRecord associations
  belongs_to :aircraft_type, class_name: 'Aircraft::Type', inverse_of: :fleets
  belongs_to :airline

  # ActiveRecord validations
  validates :aircraft_type, uniqueness: { scope: :airline }
end
