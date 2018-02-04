# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Airline::Fleet, type: :model do
  it 'has a valid factory' do
    expect(build(:airline_fleet)).to be_valid
  end

  let(:fleet) { build(:airline_fleet) }
end
