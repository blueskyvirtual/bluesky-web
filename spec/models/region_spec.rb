# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Region, type: :model do
  it 'has a valid factory' do
    expect(build(:region)).to be_valid
  end

  let(:region) { build(:region) }

  describe 'ActiveRecord associations' do
    it { expect(region).to belong_to(:country) }
  end
  # describe 'ActiveRecord associations'

  describe 'ActiveModel validations' do
    # Basic validations
    it { expect(region).to validate_presence_of(:code) }
    it { expect(region).to validate_presence_of(:local_code) }
    it { expect(region).to validate_presence_of(:name) }

    # Format validations
    it { expect(region).to_not allow_value('').for(:code) }
    it { expect(region).to_not allow_value('').for(:local_code) }
    it { expect(region).to_not allow_value('').for(:name) }

    # Inclusion/acceptance of values
    it { expect(region).to validate_uniqueness_of(:code).case_insensitive }
    it { expect(region).to validate_uniqueness_of(:local_code).scoped_to(:code).case_insensitive }
  end
  # describe 'ActiveModel validations'

  describe '#to_s' do
    before :each do
      @region = region
    end

    it 'should return: name (local_code)' do
      expect(@region.to_s).to eq "#{@region.name} (#{@region.local_code})"
    end
  end
end
