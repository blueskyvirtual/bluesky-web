# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    expect(build(:user)).to be_valid
  end

  let(:user) { build(:user) }

  describe 'ActiveRecord associations' do
    it { expect(user).to belong_to(:rank) }
    it { expect(user).to belong_to(:region) }
    it { expect(user).to have_many(:networks).through(:user_networks) }
  end
  # describe 'ActiveRecord associations'

  describe 'ActiveRecord callbacks' do
    it { expect(user).to callback(:assign_rank).before(:validation).on(:create) }
  end
  # describe 'ActiveRecord callbacks'

  describe 'ActiveModel validations' do
    # Basic validations
    it { expect(user).to validate_presence_of(:pilot_id).on(:update) }
    it { expect(user).to validate_presence_of(:first_name) }
    it { expect(user).to validate_presence_of(:last_name) }
    it { expect(user).to validate_presence_of(:email) }

    # Format validations
    it { expect(user).to_not allow_value('').for(:pilot_id).on(:update) }
    it { expect(user).to_not allow_value('').for(:first_name) }
    it { expect(user).to_not allow_value('').for(:last_name) }
    it { expect(user).to_not allow_value('').for(:email) }

    # Inclusion/acceptance of values
    it { expect(build(:user, :with_rank, :with_status)).to validate_uniqueness_of(:email).case_insensitive }
  end
  # describe 'ActiveModel validations'

  describe '#assign_rank' do
    it 'should assign the automatic rank with flight_count == 0' do
      pilot = create(:user)
      expect(pilot.rank).to eq User::Rank.find_by(automatic: true, flight_count: 0)
    end
  end

  describe '#first_name=' do
    it { expect(build(:user, first_name: 'rodger').first_name).to eq 'Rodger' }
  end

  describe '#last_name=' do
    it { expect(build(:user, last_name: 'wilco').last_name).to eq 'Wilco' }
  end

  describe '#region_display' do
    it 'displays the region name and country'
  end

  describe '#to_display' do
    it 'returns the rank name (pilot ID)' do
      pilot = build(:user)
      expect(pilot.to_display).to eq "#{pilot.rank} #{pilot.first_name} #{pilot.last_name} (#{pilot.pilot_id})"
    end
  end

  describe '#to_s' do
    before :each do
      @user = user
    end

    it 'should return: first_name last_name' do
      expect(@user.to_s).to eq "#{@user.first_name} #{@user.last_name}"
    end
  end
end
