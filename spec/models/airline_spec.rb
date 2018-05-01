# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Airline, type: :model do
  it 'has a valid factory' do
    expect(build(:airline)).to be_valid
  end

  let(:airline) { build(:airline) }

  describe 'ActiveRecord associations' do
    it { expect(airline).to have_many(:flights) }
  end

  describe 'ActiveRecord validations' do
    # Basic validations
    it { expect(airline).to validate_presence_of(:icao) }
    it { expect(airline).to validate_presence_of(:name) }

    # Format validations
    it { expect(airline).to_not allow_value('').for(:icao) }
    it { expect(airline).to_not allow_value('').for(:name) }

    # Inclusion/acceptance of values
    it { expect(airline).to validate_length_of(:icao).is_at_least(3).is_at_most(3) }
    it { expect(airline).to validate_length_of(:iata).is_at_least(2).is_at_most(3) }
    it { expect(airline).to validate_uniqueness_of(:icao).case_insensitive }
  end
  # describe 'ActiveRecord validations'

  describe '#iata=' do
    it 'upcases the input' do
      expect(build(:airline, iata: 'aa').iata).to eq 'AA'
    end
  end

  describe '#icao=' do
    it 'upcases the input' do
      expect(build(:airline, icao: 'aaa').icao).to eq 'AAA'
    end
  end

  describe '#to_option_display' do
    it 'returns the ICAO - Airline name' do
      airline = build(:airline)
      expect(airline.to_option_display).to eq "#{airline.icao} - #{airline.name}"
    end
  end
end
