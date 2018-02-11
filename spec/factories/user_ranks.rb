# frozen_string_literal: true

FactoryBot.define do
  factory :user_rank, class: 'User::Rank' do
    name { Faker::Name.name }
    # offset rank order during testing to avoid conflicts
    # with seed ranks
    sequence(:order) { |x| x + 10 }

    trait :automatic do
      sequence(:flight_count) { |i| i }
      automatic { true }
    end
  end
end
