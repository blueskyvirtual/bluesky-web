# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::Rank, type: :model do
  it 'has a valid factory' do
    expect(build(:user_rank)).to be_valid
  end

  let(:rank) { build(:user_rank) }

  describe 'ActiveRecord associations' do
    it { expect(rank).to have_many(:users) }
  end
  # describe 'ActiveRecord associations'

  describe 'ActiveRecord callbacks' do
    it { expect(rank).to callback(:ensure_no_users).before(:destroy) }
  end
  # describe 'ActiveRecord callbacks'

  describe 'ActiveModel validations' do
    # Basic validations
    it { expect(rank).to validate_presence_of(:name) }
    it { expect(rank).to validate_presence_of(:order) }
    it { expect(rank).to_not validate_presence_of(:flight_count) }

    # Format validations
    it { expect(rank).to_not allow_value('').for(:name) }

    # Inclusion/acceptance of values
    it { expect(rank).to validate_uniqueness_of(:name).case_insensitive }
    it { expect(rank).to validate_uniqueness_of(:order).case_insensitive }
    it { expect(rank.automatic).to eq false }

    # Automatic assigned ranks
    context 'for automatically assigned ranks' do
      let(:rank) { build(:user_rank, :automatic) }

      it { expect(rank.automatic).to eq true }

      it { expect(rank).to validate_numericality_of(:flight_count).is_greater_than_or_equal_to(0) }
      # it { expect(rank).to validate_uniqueness_of(:flight_count).scoped_to(:automatic) }

      context 'should validate that :flight_count' do
        it 'is unique' do
          rank1 = create(:user_rank, :automatic)
          rank2 = build(:user_rank, automatic: true, flight_count: rank1.flight_count)
          expect(rank2).to_not be_valid
        end
      end
    end
  end
  # describe 'ActiveModel validations'

  describe '#ensure_no_pilots' do
    before :each do
      @rank = create(:user_rank)
      @user = create(:user, rank: @rank)
    end

    it 'does not allow the rank to be destroyed if users are still assigned' do
      expect { @rank.destroy }.to_not change(User::Rank, :count)
    end

    it 'does not change the User count if users are still assigned' do
      expect { @rank.destroy }.to_not change(User, :count)
    end

    it 'allows the rank to be destroyed if no users are assigned' do
      @user.destroy
      expect { @rank.destroy }.to change(User::Rank, :count).by(-1)
    end
  end

  describe '#to_s' do
    before :each do
      @rank = rank
    end

    it 'should return: name' do
      expect(@rank.to_s).to eq @rank.name
    end
  end
end
