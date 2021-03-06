# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }

    pass = Faker::Internet.password(6)

    password { pass }
    password_confirmation { pass }

    trait :invalid do
      first_name { nil }
      last_name  { nil }
      email      { nil }
    end

    trait :confirmed do
      after(:create, &:confirm)
    end

    trait :with_rank do
      association :rank, factory: :user_rank
    end

    trait :with_status do
      association :user_status
    end
  end
end
