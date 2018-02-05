# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Airline::Flight::Type, type: :model do
  it 'has a valid factory' do
    expect(build(:airline_flight_type)).to be_valid
  end

  let(:type) { build(:airline_flight_type) }

  describe 'ActiveRecord associations' do
    it { expect(type).to have_many(:flights) }
  end

  describe 'ActiveRecord validations' do
    # Basic validations
    it { expect(type).to validate_presence_of(:name) }

    # Format validations
    it { expect(type).to_not allow_value('').for(:name) }

    # Inclusion/acceptance of values
    it { expect(type).to validate_uniqueness_of(:name).case_insensitive }
  end
  # describe 'ActiveRecord validations'

  describe '#to_s' do
    before :each do
      @type = type
    end

    it 'returns the name of the type' do
      expect(@type.to_s).to eq @type.name
    end
  end
end
