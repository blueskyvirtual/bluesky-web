# frozen_string_literal: true

require 'ourairports'

namespace :ourairports do
  Rails.logger = Logger.new(STDOUT)

  namespace :import do
    desc 'Import all from OurAirports'
    task all: :environment do
      Rake::Task['ourairports:import:countries'].invoke
      Rake::Task['ourairports:import:regions'].invoke
      Rake::Task['ourairports:import:airports'].invoke
      Rake::Task['ourairports:import:runways'].invoke
    end

    desc 'Import Countries from OurAirports'
    task countries: :environment do
      OurAirports::Countries.import
    end

    desc 'Import Regions from OurAirports'
    task regions: :environment do
      OurAirports::Regions.import
    end

    desc 'Import Airports from OurAirports'
    task airports: :environment do
      OurAirports::Airports.import
    end

    desc 'Import Runways from OurAirports'
    task runways: :environment do
      OurAirports::Runways.import
    end
  end
end
