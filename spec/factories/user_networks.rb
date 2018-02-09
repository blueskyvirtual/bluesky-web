# frozen_string_literal: true

FactoryBot.define do
  factory :user_network, class: 'User::Network' do
    association(:network)
    association(:user)

    sequence(:username) { |x| x }
  end
end
