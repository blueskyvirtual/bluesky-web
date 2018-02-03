# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Airport::Runway, type: :model do
  it 'has a valid factory' do
    expect(build(:airport_runway)).to be_valid
  end

  let(:runway) { build(:airport_runway) }

  describe 'ActiveRecord associations' do
    it { expect(runway).to belong_to(:airport) }
  end
  # describe 'ActiveRecord associations'

  describe 'ActiveModel validations' do
    # Basic validations
    it { expect(runway).to validate_presence_of(:l_ident) }
    it { expect(runway).to validate_presence_of(:length) }

    # Format validations
    it { expect(runway).to_not allow_value('').for(:l_ident) }
    it { expect(runway).to validate_numericality_of(:length).only_integer }
    it { expect(runway).to validate_numericality_of(:width).only_integer }

    # Inclusion/acceptance of values
    it { expect(runway).to validate_length_of(:l_ident).is_at_most(3) }
    it { expect(runway).to validate_length_of(:h_ident).is_at_most(3) }
    # it { expect(runway).to validate_uniqueness_of(:l_ident).scoped_to(:airport).case_insensitive }
    # it { expect(runway).to validate_uniqueness_of(:h_ident).scoped_to(:airport).case_insensitive }

    it { expect(runway).to validate_numericality_of(:l_heading).is_less_than_or_equal_to(360) }
    it { expect(runway).to validate_numericality_of(:l_heading).is_greater_than_or_equal_to(0) }
    it { expect(runway).to validate_numericality_of(:h_heading).is_less_than_or_equal_to(360) }
    it { expect(runway).to validate_numericality_of(:h_heading).is_greater_than_or_equal_to(0) }
  end
  # describe 'ActiveModel validations'

  describe '#ident' do
    before :each do
      @runway = runway
    end

    it 'combines the lower ident and higher ident' do
      expect(@runway.ident).to eq "#{@runway.l_ident}/#{@runway.h_ident}"
    end

    it 'shows just the lower ident if higher ident is nil' do
      @runway.h_ident = nil
      expect(@runway.ident).to eq @runway.l_ident.to_s
    end
  end

  describe '#to_s' do
    before :each do
      @runway = runway
    end

    it 'returns Airport ident (ident)' do
      expect(@runway.to_s).to eq "#{@runway.airport.ident} #{@runway.ident}"
    end
  end
end
