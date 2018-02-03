# frozen_string_literal: true

FactoryBot.define do
  factory :region do
    association(:country)
    sequence(:code, &:to_s)
    sequence(:local_code, &:to_s)
    name { Faker::Name.name }
  end
end
