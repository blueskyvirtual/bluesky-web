# frozen_string_literal: true

FactoryBot.define do
  factory :airline_fleet, class: 'Airline::Fleet' do
    association(:airline)
    association(:aircraft_type)
  end
end
