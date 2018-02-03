# frozen_string_literal: true

class Airport::Runway < ApplicationRecord
  # Audit
  audited

  # ActiveRecord associations
  belongs_to :airport

  # ActiveRecord validations
  validates :l_ident,
            presence:     true,
            allow_blank:  false,
            length:       { maximum: 3 },
            uniqueness:   { case_sensitive: false, scope: :airport }

  validates :h_ident,
            allow_blank:  true,
            length:       { maximum: 3 },
            uniqueness:   { case_sensitive: false, scope: :airport }

  validates :length,
            presence:     true,
            allow_blank:  false,
            numericality: { only_integer: true }

  validates :width,
            presence:     true,
            allow_blank:  true,
            numericality: { only_integer: true }

  validates :l_heading,
            numericality: {
              less_than_or_equal_to:    360,
              greater_than_or_equal_to: 0,
              only_integer: true
            }

  validates :h_heading,
            numericality: {
              less_than_or_equal_to:    360,
              greater_than_or_equal_to: 0,
              only_integer: true
            }

  # Returns the identifier for the runway
  # ex. "15L/33R" or just "33"
  def ident
    return l_ident.to_s if h_ident.nil?
    "#{l_ident}/#{h_ident}"
  end

  def to_s
    "#{airport.ident} #{ident}"
  end
end
