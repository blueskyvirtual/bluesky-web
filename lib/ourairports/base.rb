# frozen_string_literal: true

require 'csv'
require 'observer'
require 'open-uri'

module OurAirports
  class Base
    include Observable

    def initialize(url)
      @url    = url
      @logger = nil

      begin
        update_progress("Downloading from: #{url}", 0, 0)
        @raw = open(url.to_s, &:read)
      rescue StandardError
        # TODO: rescue errors properly
        nil
      end
    end

    def record_logs_off
      # Silence active record logging to avoid filling
      @logger = ActiveRecord::Base.logger
      ActiveRecord::Base.logger = nil
    end

    def record_logs_on
      # Silence active record logging to avoid filling
      ActiveRecord::Base.logger = @logger unless @logger.nil?
    end

    def parse
      list = []

      count = 0

      CSV.parse(@raw, headers: true, header_converters: :symbol) do |row|
        count += 1
        update_progress('Parsing', count, 0)
        list.push row
      end

      list
    end

    def update_progress(msg, count, total)
      notify_observers(msg, count, total)

      # rubocop:disable Style/GuardClause
      if Rails.logger.level.zero?
        Rails.logger.debug "#{self.class.name}: #{count} of #{total}: #{msg}"
      end
      # rubocop:enable Style/GuardClause
    end

    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def self.import(url)
      klass = new(url)

      # Turn off ActiveRecord logging
      klass.record_logs_off

      # counters
      count = 0
      update_count = 0

      list = klass.parse

      list.each do |row|
        record = yield row
        count += 1

        # skip if the record comes back empty
        next if record.nil?

        if record.valid?
          if record.changed?
            record.save_without_auditing
            update_count += 1
            klass.update_progress("#{record} updated", count, list.size)
          else
            klass.update_progress("#{record}, no change", count, list.size)
          end
        else
          errors = record.errors.full_messages.join(', ')
          klass.update_progress("#{record} error", count, list.size)
          Rails.logger.debug "#{klass.class.name}: #{record}: #{errors}"
        end
      end

      # Reset logging
      klass.record_logs_on

      klass.update_progress('Updated', update_count, list.size)
      Rails.logger.info "#{klass.class.name} updated: #{update_count}"
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
  end
end
