# frozen_string_literal: true

require 'rails_helper'
require 'ourairports'

RSpec.describe OurAirports::Base do
  let(:our_airports) { OurAirports::Base.new('http://ourairports/test.csv') }

  before :each do
    stub_request(
      :get,
      'http://ourairports/test.csv'
    ).to_return(body: open('spec/fixtures/ourairports/base.csv', &:read).to_s)
  end

  describe '#initialization' do
    context 'with invalid URL' do
      let(:our_airports) { OurAirports::Base.new('test://localhost') }

      it 'does not raise on connection errors' do
        expect { our_airports }.to_not raise_exception
      end

      it 'calls #update_progress to notify observers' do
        expect_any_instance_of(OurAirports::Base).to receive(:update_progress).with('Downloading from: test://localhost')
        expect_any_instance_of(OurAirports::Base).to receive(:update_progress).with('Unable to retrieve from: test://localhost')
        our_airports
      end
    end

    context 'with a valid URL' do
      it 'calls #update_progress to notify observers' do
        expect_any_instance_of(OurAirports::Base).to receive(:update_progress).with('Downloading from: http://ourairports/test.csv')
        our_airports
      end

      it 'downloads the contents of the URL to the @raw instance variable' do
        expect(our_airports.instance_variable_get(:@raw)).to_not be_empty
      end
    end
  end
  # describe '#initialization'

  describe '#record_logs_off' do
    before :each do
      ActiveRecord::Base.logger = ActiveSupport::Logger.new('/dev/null')
    end

    it 'saves the original ActiveRecord logger' do
      our_airports.record_logs_off
      expect(our_airports.instance_variable_get(:@logger)).to be_kind_of ActiveSupport::Logger
    end

    it 'does not lose the original logger if called multiple times' do
      our_airports.record_logs_off
      our_airports.record_logs_off
      expect(our_airports.instance_variable_get(:@logger)).to be_kind_of ActiveSupport::Logger
    end

    it 'disables ActiveRecord query logging' do
      our_airports.record_logs_off
      expect(ActiveRecord::Base.logger).to eq nil
    end
  end
  # describe '#record_logs_off'

  describe '#record_logs_on' do
    before :each do
      @orig_log = ActiveSupport::Logger.new('/dev/null')
      ActiveRecord::Base.logger = @orig_log
    end

    it 'restores the original ActiveRecord logger' do
      our_airports.record_logs_off
      our_airports.record_logs_on
      expect(@orig_log).to eq ActiveRecord::Base.logger
    end

    it 'does nothing if @logger is nil' do
      our_airports.record_logs_on
      expect(our_airports.instance_variable_get(:@logger)).to_not eq ActiveRecord::Base.logger
    end
  end
  # describe '#record_logs_on'

  describe '#parse' do
    it 'returns parsed download into an array' do
      expect(our_airports.parse).to be_a Array
    end

    it 'returns parsed download array containing CSV rows' do
      expect(our_airports.parse.first).to be_a CSV::Row
    end

    it 'returns the correct contents of the CSV' do
      expect(our_airports.parse.first[:col1]).to eq 'this'
      expect(our_airports.parse.first[:col2]).to eq 'is'
      expect(our_airports.parse.first[:col3]).to eq 'a'
      expect(our_airports.parse.first[:col4]).to eq 'test'
      expect(our_airports.parse.first[:col5]).to eq 'message'
    end
  end
  # describe '#parse'

  describe '#update_progress' do
    it 'notifies observers' do
      expect_any_instance_of(OurAirports::Base).to receive(:notify_observers).with('Downloading from: http://ourairports/test.csv', nil, nil)
      expect_any_instance_of(OurAirports::Base).to receive(:notify_observers).with('Test', nil, nil)
      our_airports.update_progress('Test')
    end

    it 'logs to the Rails log' do
      expect(Rails.logger).to receive(:debug).exactly(2).times
      our_airports.update_progress('Test')
    end

    it 'does not log to the Rails log if the level is above debug' do
      Rails.logger.level = :info
      expect(Rails.logger).to_not receive(:debug)
      our_airports.update_progress('Test')
      Rails.logger.level = :debug
    end
  end
  # describe '#update_progress'

  # describe '#self.import'
  # Tested via inherited classes
end
