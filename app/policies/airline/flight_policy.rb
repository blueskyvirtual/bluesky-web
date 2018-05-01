# frozen_string_literal: true

class Airline
  class FlightPolicy < ApplicationPolicy
    def index?
      true
    end

    def create?
      true
    end

    def destroy?
      true
    end

    def show?
      true
    end

    def update?
      true
    end

    def permitted_attributes
      %i[airline_id flight flight_type_id aircraft_type_id
         origin_id destination_id dep_time arv_time]
    end
  end
end
