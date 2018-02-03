# frozen_string_literal: true

FactoryBot.define do
  factory :country do
    sequence(:code, &:to_s)
    sequence(:name) { |y| "Country #{y}" }
  end
end
