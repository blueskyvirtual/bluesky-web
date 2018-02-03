# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Airport, type: :model do
  it 'has a valid factory' do
    expect(build(:airport)).to be_valid
  end

  let(:airport) { build(:airport) }

  describe 'ActiveRecord associations' do
    it { expect(airport).to belong_to(:region) }
  end
  # describe 'ActiveRecord associations'

  describe 'ActiveModel validations' do
    # Basic validations
    it { expect(airport).to validate_presence_of(:ident) }
    it { expect(airport).to validate_presence_of(:name) }
    it { expect(airport).to validate_presence_of(:location) }

    # Format validations
    it { expect(airport).to_not allow_value('').for(:ident) }
    it { expect(airport).to_not allow_value('').for(:name) }

    # Inclusion/acceptance of values
    it { expect(airport).to validate_length_of(:ident).is_at_most(4) }
    it { expect(airport).to validate_length_of(:iata).is_at_most(3) }
    it { expect(airport).to validate_uniqueness_of(:ident).case_insensitive }
  end
  # describe 'ActiveModel validations'

  describe 'ActiveRecord delegations' do
    it { expect(airport).to respond_to(:country) }
  end
  # describe 'ActiveRecord delegations'

  describe '#city' do
    before :each do
      @airport = airport
    end

    it 'returns the municipality if present' do
      @airport.municipality = 'Houston'
      expect(@airport.city).to eq 'Houston'
    end

    it 'returns the airport name if municipality is blank' do
      expect(@airport.city).to eq @airport.name
    end
  end
  # describe '#city'

  describe '#to_display' do
    before :each do
      @airport = airport

      it 'returns the city, local_code (ident)' do
        string = "#{@airport.city}, #{@airport.region.local_code} (#{@airport.ident})"
        # rubocop:enable Metrics/LineLength
        expect(@airport.to_display).eq string
      end
    end
  end

  describe '#to_s' do
    before :each do
      @airport = airport
    end

    it 'returns name (ident)' do
      expect(@airport.to_s).to eq "#{@airport.name} (#{@airport.ident})"
    end
  end
end
