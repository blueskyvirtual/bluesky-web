# frozen_string_literal: true

class Airline::Flight::Type < ApplicationRecord
  # Audits
  audited

  # ActiveRecord associations
  has_many :flights,
           class_name: 'Airline::Flight',
           inverse_of: :type,
           dependent:  :destroy

  # ActiveRecord validations
  validates :name,
            presence:     true,
            allow_blank:  false,
            uniqueness:   { case_sensitive: false }

  # Return the name
  def to_s
    name
  end
end
