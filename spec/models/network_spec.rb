# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Network, type: :model do
  it 'has a valid factory' do
    expect(build(:network)).to be_valid
  end

  let(:network) { build(:network) }

  describe 'ActiveRecord associations' do
    it{ expect(network).to have_many(:user_flights) }
  end

  describe 'ActiveRecord validations' do
    # Basic validations
    it { expect(network).to validate_presence_of(:name) }

    # Format validations

    # Inclusion/acceptance of values
    it { expect(network).to_not allow_value('').for(:name) }
    it { expect(network).to validate_uniqueness_of(:name).case_insensitive }
  end
  # describe 'ActiveRecord validations'

  describe '#to_s' do
    it 'returns the name of the network' do
      expect(network.to_s).to eq network.name
    end
  end
end
