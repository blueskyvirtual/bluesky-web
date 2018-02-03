# frozen_string_literal: true

FactoryBot.define do
  factory :airport_runway, class: 'Airport::Runway' do
    association(:airport)
    l_ident { rand(0..36).to_s }
    h_ident { rand(0..36).to_s }
    length { rand(1..12_500) }
  end
end
