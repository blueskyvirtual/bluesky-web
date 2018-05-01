# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::Network, type: :model do
  it 'has a valid factory' do
    expect(build(:user_network)).to be_valid
  end

  let(:user_network) { build(:user_network) }

  describe 'ActiveRecord associations' do
    it { expect(user_network).to belong_to(:network) }
    it { expect(user_network).to belong_to(:user) }
  end

  describe 'ActiveRecord validations' do
    # Basic validations
    it { expect(user_network).to validate_presence_of(:username) }

    # Format validations

    # Inclusion/acceptance of values
    it { expect(user_network).to_not allow_value('').for(:username) }
  end
  # describe 'ActiveRecord validations'

  describe 'around save #catch_uniqueness_exception' do
    before :each do
      @user     = create(:user)
      @network  = create(:network)
      @network1 = build(:user_network, user: @user, network: @network).attributes
      @network2 = build(:user_network, user: @user, network: @network).attributes
    end

    it 'should prevent users from having multiples of the same network' do
      expect do
        @user.update_attributes(user_networks_attributes: { '0' => @network1, '1' => @network2 })
      end.to_not change(User::Network, :count)
    end
  end
end
