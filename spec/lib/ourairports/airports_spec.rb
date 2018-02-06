# frozen_string_literal: true

require 'rails_helper'
require 'ourairports'

RSpec.describe OurAirports::Airports do
  let(:airports) { OurAirports::Airports.import('http://ourairports/airports.csv') }

  before :each do
    stub_request(
      :get,
      'http://ourairports/airports.csv'
    ).to_return(body: open('spec/fixtures/ourairports/airports.csv', &:read).to_s)

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

    OurAirports::Countries.import('http://ourairports/countries.csv')
    OurAirports::Regions.import('http://ourairports/regions.csv')
  end

  describe '#import' do
    it 'creates new airport objects' do
      expect { airports }.to change(Airport, :count).by(4)
    end

    it 'does not modify existing objects' do
      airports # import then import again
      expect { airports }.to_not change(Airport, :count)
    end

    it 'does not raise on CSV errors' do
      expect { airports }.to_not raise_error
    end
  end
  # describe '#import'
end
