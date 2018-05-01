# frozen_string_literal: true

FactoryBot.define do
  factory :airline_flight, class: 'Airline::Flight' do
    association :airline,        factory: :airline
    association :origin,         factory: :airport
    association :destination,    factory: :airport
    association :aircraft_type,  factory: :aircraft_type
    association :flight_type,    factory: :airline_flight_type

    flight   { rand(1..9999) }
    dep_time { Time.now.utc.strftime '%H:%M' }
    arv_time { (Time.now.utc + 2.hours).strftime '%H:%M' }

    trait :invalid do
      flight      { nil }
      origin      { nil }
      destination { nil }
      dep_time    { nil }
      arv_time    { nil }
    end
  end
end
