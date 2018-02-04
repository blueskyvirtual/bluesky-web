# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180204190348) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"
  enable_extension "pgcrypto"

  create_table "aircraft_types", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "icao", null: false
    t.string "iata"
    t.string "name", null: false
    t.index ["icao"], name: "index_aircraft_types_on_icao"
  end

  create_table "airline_fleets", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "airline_id", null: false
    t.uuid "aircraft_type_id", null: false
  end

  create_table "airline_flights", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "fleet_id", null: false
    t.integer "flight", null: false
    t.uuid "origin_id", null: false
    t.uuid "destination_id", null: false
    t.time "dep_time", null: false
    t.time "arv_time", null: false
    t.index ["destination_id"], name: "index_airline_flights_on_destination_id"
    t.index ["origin_id"], name: "index_airline_flights_on_origin_id"
  end

  create_table "airlines", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "icao", limit: 3, null: false
    t.string "iata", limit: 3
    t.string "name", null: false
    t.index ["icao"], name: "index_airlines_on_icao"
  end

  create_table "airport_runways", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "airport_id", null: false
    t.string "l_ident", null: false
    t.string "h_ident"
    t.integer "length", null: false
    t.integer "width"
    t.integer "l_heading", default: 0
    t.integer "h_heading", default: 0
    t.integer "l_displaced_threshold"
    t.integer "h_displaced_threshold"
    t.geography "l_location", limit: {:srid=>4326, :type=>"st_point", :has_z=>true, :geographic=>true}
    t.geography "h_location", limit: {:srid=>4326, :type=>"st_point", :has_z=>true, :geographic=>true}
  end

  create_table "airports", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "ident", null: false
    t.string "iata"
    t.string "name", null: false
    t.string "municipality"
    t.uuid "region_id", null: false
    t.geography "location", limit: {:srid=>4326, :type=>"st_point", :has_z=>true, :geographic=>true}, null: false
    t.index ["iata"], name: "index_airports_on_iata"
    t.index ["ident"], name: "index_airports_on_ident"
    t.index ["location"], name: "index_airports_on_location", using: :gist
  end

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "countries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.index ["code"], name: "index_countries_on_code"
  end

  create_table "regions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "code", null: false
    t.string "local_code", null: false
    t.string "name", null: false
    t.uuid "country_id", null: false
    t.index ["code"], name: "index_regions_on_code"
    t.index ["local_code"], name: "index_regions_on_local_code"
  end

end
