# frozen_string_literal: true

FactoryBot.define do
  factory :user_network, class: 'User::Network' do
    association(:network)
    association(:user, :confirmed)

    sequence(:username) { |x| x }
  end
end
