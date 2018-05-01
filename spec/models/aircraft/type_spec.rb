# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Aircraft::Type, type: :model do
  it 'has a valid factory' do
    expect(build(:aircraft_type)).to be_valid
  end

  let(:type) { build(:aircraft_type) }

  describe 'ActiveRecord associations' do
    it { expect(type).to have_many(:airline_flights) }
    it { expect(type).to have_many(:user_flights) }
  end

  describe 'ActiveRecord validations' do
    # Basic validations
    it { expect(type).to validate_presence_of(:icao) }
    it { expect(type).to validate_presence_of(:name) }

    # Format validations
    it { expect(type).to_not allow_value('').for(:icao) }
    it { expect(type).to_not allow_value('').for(:name) }

    # Inclusion/acceptance of values
    it { expect(type).to validate_length_of(:icao).is_at_least(2).is_at_most(4) }
    it { expect(type).to validate_length_of(:iata).is_at_most(3) }
    it { expect(type).to validate_uniqueness_of(:icao).case_insensitive }
  end
  # describe 'ActiveRecord validations'

  describe '#iata=' do
    it 'upcases the input' do
      expect(build(:aircraft_type, iata: 'aa').iata).to eq 'AA'
    end
  end

  describe '#icao=' do
    it 'upcases the input' do
      expect(build(:aircraft_type, icao: 'aaa').icao).to eq 'AAA'
    end
  end
end
