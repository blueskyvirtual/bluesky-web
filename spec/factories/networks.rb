# frozen_string_literal: true

FactoryBot.define do
  factory :network do
    name { Faker::Internet.domain_word }
  end
end
