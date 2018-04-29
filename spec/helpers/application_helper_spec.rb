# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#date_display' do
    before :each do
      @regexp = %r{^\d{2}\/\d{2}\/\d{4}$}
    end

    it 'returns a formatted date from a record and column' do
      record = build(:user_flight)
      expect(helper.date_display(record, :time_in)).to match @regexp
    end

    it 'returns a formatted date from a time object' do
      date = Time.now.utc
      expect(helper.date_display(date)).to match @regexp
    end
  end

  describe '#datetime_display' do
    before :each do
      @regexp = %r{^\d{2}\/\d{2}\/\d{4} \d{2}:\d{2} \w{3}$}
    end

    it 'returns a formatted datetime from a record and column' do
      record = build(:user_flight)
      expect(helper.datetime_display(record, :time_in)).to match @regexp
    end

    it 'returns a formatted datetime from a time object' do
      date = Time.now.utc
      expect(helper.datetime_display(date)).to match @regexp
    end
  end
end
