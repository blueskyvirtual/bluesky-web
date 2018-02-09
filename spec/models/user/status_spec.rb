# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::Status, type: :model do
  it 'has a valid factory' do
    expect(build(:user_status)).to be_valid
  end

  let(:status) { build(:user_status) }

  describe 'ActiveRecord associations' do
    it { expect(status).to have_many(:users) }
  end

  describe 'ActiveRecord validations' do
    # Basic validations
    it { expect(status).to validate_presence_of(:name) }

    # Format validations

    # Inclusion/acceptance of values
    it { expect(status).to_not allow_value('').for(:name) }
  end
  # describe 'ActiveRecord validations'

  describe '#name=' do
    it 'titleizes the name' do
      new_status = build(:user_status, name: 'test')
      expect(new_status.name).to eq 'Test'
    end
  end

  describe '#to_s' do
    it 'returns the name of the status object' do
      expect(status.to_s).to eq status.name
    end
  end
end
