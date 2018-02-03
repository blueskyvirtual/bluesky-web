# frozen_string_literal: true

FactoryBot.define do
  factory :airport do
    association(:region)
    sequence(:ident, &:to_s)

    name      { Faker::Name.name }
    location  { "POINT(#{Faker::Address.longitude} #{Faker::Address.latitude} 0)" }
  end
end
