# frozen_string_literal: true

require 'rails_helper'
require 'ourairports'

RSpec.describe OurAirports::Countries do
  let(:countries) { OurAirports::Countries.import('http://ourairports/countries.csv') }

  before :each do
    stub_request(
      :get,
      'http://ourairports/countries.csv'
    ).to_return(body: open('spec/fixtures/ourairports/countries.csv', &:read).to_s)
  end

  describe '#import' do
    it 'creates new country objects' do
      expect { countries }.to change(Country, :count).by(2)
    end

    it 'does not modify existing objects' do
      countries # import then import again
      expect { countries }.to_not change(Country, :count)
    end

    it 'does not raise on CSV errors' do
      expect { countries }.to_not raise_error
    end
  end
  # describe '#import'
end
