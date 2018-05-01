# frozen_string_literal: true

FactoryBot.define do
  factory :airline do
    sequence(:icao) { |i| ('AAA'..'ZZZ').to_a[i] }
    name { Faker::Name.name }

    trait :invalid do
      icao { nil }
      name { nil }
    end
  end
end
