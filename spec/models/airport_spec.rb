# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Airport, type: :model do
  it 'has a valid factory' do
    expect(build(:airport)).to be_valid
  end

  let(:airport) { build(:airport) }

  describe 'ActiveRecord associations' do
    it { expect(airport).to belong_to(:region) }
    it { expect(airport).to have_many(:arrivals) }
    it { expect(airport).to have_many(:departures) }
    it { expect(airport).to have_many(:users) }
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
    end

    it 'returns the city, local_code (ident)' do
      string = "#{@airport.city}, #{@airport.country.code} (#{@airport.ident})"
      expect(@airport.to_display).to eq string
    end
  end

  describe '#to_municipality_display' do
    before :each do
      @us = create(:country, code: 'US')
      @eu = create(:country, code: 'EU')

      @us_region = create(:region, country: @us, local_code: 'TX')
      @eu_region = create(:region, country: @eu, local_code: 'GB')
    end

    it 'displays the City, State if inside the US' do
      airport = build(:airport, region: @us_region)
      expect_str = "#{airport.city}, #{@us_region.local_code}"
      expect(airport.to_municipality_display).to eq expect_str
    end

    it 'displays the City, Country if outside the US' do
      airport = build(:airport, region: @eu_region)
      expect_str = "#{airport.city}, #{@eu.code}"
      expect(airport.to_municipality_display).to eq expect_str
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
