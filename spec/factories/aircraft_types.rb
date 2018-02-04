# frozen_string_literal: true

FactoryBot.define do
  factory :aircraft_type, class: 'Aircraft::Type' do
    sequence(:icao) { |i| ('aa'..'zzzz').to_a[i] }
    sequence(:name) { |n| "Model #{n}" }
  end
end
