# frozen_string_literal: true

class Airline
  class FlightPolicy < ApplicationPolicy
    def index?
      true
    end
  end
end
