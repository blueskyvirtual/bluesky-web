# frozen_string_literal: true

FactoryBot.define do
  factory :airline_flight, class: 'Airline::Flight' do
    association :fleet,       factory: :airline_fleet
    association :origin,      factory: :airport
    association :destination, factory: :airport
    association :type,        factory: :airline_flight_type

    sequence(:flight) { |n| n }

    dep_time { Time.now.utc.strftime '%H:%M' }
    arv_time { (Time.now.utc + 2.hours).strftime '%H:%M' }
  end
end
