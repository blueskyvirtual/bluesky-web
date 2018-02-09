# frozen_string_literal: true

FactoryBot.define do
  factory :user_status, class: 'User::Status' do
    name { Faker::Name.name }
  end
end
