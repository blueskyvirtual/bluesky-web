# frozen_string_literal: true

FactoryBot.define do
  factory :airline_flight_type, class: 'Airline::Flight::Type' do
    name { Faker::Name.first_name }
  end
end
