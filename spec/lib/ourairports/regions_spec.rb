# frozen_string_literal: true

require 'rails_helper'
require 'ourairports'

RSpec.describe OurAirports::Regions do
  let(:regions) { OurAirports::Regions.import('http://ourairports/regions.csv') }

  before :each do
    stub_request(
      :get,
      'http://ourairports/regions.csv'
    ).to_return(body: open('spec/fixtures/ourairports/regions.csv', &:read).to_s)

    # Dependent on countries
    stub_request(
      :get,
      'http://ourairports/countries.csv'
    ).to_return(body: open('spec/fixtures/ourairports/countries.csv', &:read).to_s)

    OurAirports::Countries.import('http://ourairports/countries.csv')
  end

  describe '#import' do
    it 'creates new region objects' do
      expect { regions }.to change(Region, :count).by(8)
    end

    it 'does not modify existing objects' do
      regions # import then import again
      expect { regions }.to_not change(Region, :count)
    end

    it 'does not raise on CSV errors' do
      expect { regions }.to_not raise_error
    end
  end
  # describe '#import'
end
