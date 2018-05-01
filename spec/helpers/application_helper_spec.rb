# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#date_display' do
    before :each do
      @regexp = %r{^\d{2}\/\d{2}\/\d{4}$}
    end

    it 'returns a formatted date from a record and column' do
      record = build(:airline_flight)
      expect(helper.date_display(record, :dep_time)).to match @regexp
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
      record = build(:airline_flight)
      expect(helper.datetime_display(record, :dep_time)).to match @regexp
    end

    it 'returns a formatted datetime from a time object' do
      date = Time.now.utc
      expect(helper.datetime_display(date)).to match @regexp
    end
  end

  describe '#find_time' do
    it 'returns time in the timezone of the geo object' do
      a = Airport.create(
          ident:    'KIAH',
          iata:     'IAH',
          name:     'Houston',
          region:   create(:region),
          location: 'POINT (-95.34140014648438 29.984399795532227 97.0)'
      )

      time = Time.now

      Time.use_zone('America/Chicago') do
        expect(helper.find_time(a, time)).to eq time
      end
    end
  end

  describe '#find_timezone' do
    it 'returns the timezone for a geo object' do
      a = Airport.create(
          ident:    'KIAH',
          iata:     'IAH',
          name:     'Houston',
          region:   create(:region),
          location: 'POINT (-95.34140014648438 29.984399795532227 97.0)'
      )

      expect(helper.find_timezone(a)).to eq 'America/Chicago'
    end
  end

  describe '#time_display' do
    before :each do
      @regexp = %r{^\d{2}:\d{2} \w+$}
    end

    it 'returns a formatted time from a record and column' do
      record = build(:airline_flight)
      expect(helper.time_display(record, :dep_time)).to match @regexp
    end

    it 'returns a formatted time from a time object' do
      time = Time.now.utc
      expect(helper.time_display(time)).to match @regexp
    end
  end
end
