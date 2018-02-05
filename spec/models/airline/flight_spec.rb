# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Airline::Flight, type: :model do
  it 'has a valid factory' do
    expect(build(:airline_flight)).to be_valid
  end

  let(:flight) { build(:airline_flight) }

  describe 'ActiveRecord associations' do
    it { expect(flight).to delegate_method(:airline).to(:fleet) }
    it { expect(flight).to belong_to(:fleet) }
    it { expect(flight).to belong_to(:origin) }
    it { expect(flight).to belong_to(:destination) }
    it { expect(flight).to belong_to(:type) }
  end

  describe 'ActiveRecord validations' do
    # Basic validations
    it { expect(flight).to validate_presence_of(:flight) }
    it { expect(flight).to validate_presence_of(:dep_time) }
    it { expect(flight).to validate_presence_of(:arv_time) }

    # Format validations
    it { expect(flight).to_not allow_value('').for(:flight) }
    it { expect(flight.dep_time.class).to eq ActiveSupport::TimeWithZone }
    it { expect(flight.arv_time.class).to eq ActiveSupport::TimeWithZone }

    # Inclusion/acceptance of values
    it { expect(flight).to validate_numericality_of(:flight).is_greater_than_or_equal_to(0) }
  end
  # describe 'ActiveRecord validations'
end
