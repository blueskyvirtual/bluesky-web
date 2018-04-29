# frozen_string_literal: true

FactoryBot.define do
  factory :user_flight, class: 'User::Flight' do
    association :user
    association :airline_flight
    association :aircraft_type

    time_out { Faker::Time.between(2.days.ago, Time.now.utc, :all) }
    time_off { time_out + 20.minutes }
    time_on  { time_off + rand(1..5).hours + rand(1..59).minutes }
    time_in  { time_on  + 10.minutes }

    route { 'TEST ROUTE' }
  end
end
