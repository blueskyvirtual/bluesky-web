# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::Flight, type: :model do
  it 'has a valid factory' do
    expect(build(:user_flight)).to be_valid
  end

  let(:flight) { build(:user_flight) }

  describe 'ActiveRecord associations' do
    it { expect(flight).to belong_to(:user) }
    it { expect(flight).to belong_to(:airline_flight) }
    it { expect(flight).to belong_to(:aircraft_type) }
    it { expect(flight).to belong_to(:network) }
  end
  # describe 'ActiveRecord associations'

  describe 'ActiveModel validations' do
    # Basic validations
    it { expect(flight).to validate_presence_of(:time_out) }
    it { expect(flight).to validate_presence_of(:time_off) }
    it { expect(flight).to validate_presence_of(:time_on) }
    it { expect(flight).to validate_presence_of(:time_in) }
    it { expect(flight).to validate_presence_of(:route) }
    # it { expect(flight).to validate_presence_of(:duration) }
    # it { expect(flight).to validate_numericality_of(:duration).is_greater_than(0) }

    # Format validations
    it { expect(flight).to_not allow_value('').for(:time_out) }
    it { expect(flight).to_not allow_value('').for(:time_off) }
    it { expect(flight).to_not allow_value('').for(:time_on) }
    it { expect(flight).to_not allow_value('').for(:time_in) }
    it { expect(flight).to_not allow_value('').for(:route) }

    it { expect(flight).to allow_value(nil).for(:remarks) }
    it { expect(flight).to allow_value(nil).for(:network) }

    # Inclusion/acceptance of values
    ## Basic future time validations
    it { expect(flight).to_not allow_value(Time.now.utc + 1.second).for(:time_out) }
    it { expect(flight).to_not allow_value(Time.now.utc + 1.second).for(:time_off) }
    it { expect(flight).to_not allow_value(Time.now.utc + 1.second).for(:time_on) }
    it { expect(flight).to_not allow_value(Time.now.utc + 1.second).for(:time_in) }

    ## Basic time ordering validations
    it { expect(flight).to_not allow_value(flight.time_out - 1.second).for(:time_off) }
    it { expect(flight).to_not allow_value(flight.time_off - 1.second).for(:time_on) }
    it { expect(flight).to_not allow_value(flight.time_on  - 1.second).for(:time_in) }
  end
  # describe 'ActiveModel validations'
end
