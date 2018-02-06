# frozen_string_literal: true

require 'rails_helper'
require 'ourairports'

RSpec.describe OurAirports::Runways do
  let(:runways) { OurAirports::Runways.import('http://ourairports/runways.csv') }

  before :each do
    stub_request(
      :get,
      'http://ourairports/runways.csv'
    ).to_return(body: open('spec/fixtures/ourairports/runways.csv', &:read).to_s)

    # Dependent on countries
    stub_request(
      :get,
      'http://ourairports/countries.csv'
    ).to_return(body: open('spec/fixtures/ourairports/countries.csv', &:read).to_s)

    # Dependent on regions
    stub_request(
      :get,
      'http://ourairports/regions.csv'
    ).to_return(body: open('spec/fixtures/ourairports/regions.csv', &:read).to_s)

    # Dependent on airports
    stub_request(
      :get,
      'http://ourairports/airports.csv'
    ).to_return(body: open('spec/fixtures/ourairports/airports.csv', &:read).to_s)

    OurAirports::Countries.import('http://ourairports/countries.csv')
    OurAirports::Regions.import('http://ourairports/regions.csv')
    OurAirports::Airports.import('http://ourairports/airports.csv')
  end

  describe '#import' do
    it 'creates new runway objects' do
      expect { runways }.to change(Airport::Runway, :count).by(8)
    end

    it 'does not modify existing objects' do
      runways # import then import again
      expect { runways }.to_not change(Airport::Runway, :count)
    end

    it 'does not raise on CSV errors' do
      expect { runways }.to_not raise_error
    end
  end
  # describe '#import'
end
