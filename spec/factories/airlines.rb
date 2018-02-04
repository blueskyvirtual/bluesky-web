# frozen_string_literal: true

FactoryBot.define do
  factory :airline do
    sequence(:icao) { |i| ('AAA'..'ZZZ').to_a[i] }
    name { Faker::Name.name }
  end
end
