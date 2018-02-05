# frozen_string_literal: true

FactoryBot.define do
  factory :rank do
    name { Faker::Name.name }

    trait :automatic do
      sequence(:flight_count) { |i| i }
      automatic { true }
    end
  end
end
