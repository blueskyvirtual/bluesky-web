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

ActiveRecord::Schema.define(version: 20180219213611) do

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

  create_table "airline_flight_types", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "airline_flights", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "fleet_id", null: false
    t.integer "flight", null: false
    t.uuid "origin_id", null: false
    t.uuid "destination_id", null: false
    t.time "dep_time", null: false
    t.time "arv_time", null: false
    t.uuid "type_id", null: false
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

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "networks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.text "url"
    t.text "stats_url"
  end

  create_table "regions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "code", null: false
    t.string "local_code", null: false
    t.string "name", null: false
    t.uuid "country_id", null: false
    t.index ["code"], name: "index_regions_on_code"
    t.index ["local_code"], name: "index_regions_on_local_code"
  end

  create_table "user_networks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "network_id", null: false
    t.string "username", null: false
  end

  create_table "user_ranks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.integer "flight_count"
    t.integer "order", null: false
    t.boolean "automatic", default: false
  end

  create_table "user_statuses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.boolean "allow_login", default: true
    t.boolean "show_on_roster", default: true
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.uuid "rank_id", null: false
    t.uuid "home_airport_id"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "pilot_id", null: false
    t.uuid "user_status_id", null: false
    t.uuid "region_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "airline_fleets", "aircraft_types"
  add_foreign_key "airline_fleets", "airlines"
  add_foreign_key "airline_flights", "airline_fleets", column: "fleet_id"
  add_foreign_key "airline_flights", "airline_flight_types", column: "type_id"
  add_foreign_key "airline_flights", "airports", column: "destination_id"
  add_foreign_key "airline_flights", "airports", column: "origin_id"
  add_foreign_key "airport_runways", "airports"
  add_foreign_key "regions", "countries"
  add_foreign_key "user_networks", "networks"
  add_foreign_key "users", "airports", column: "home_airport_id"
  add_foreign_key "users", "regions"
  add_foreign_key "users", "user_ranks", column: "rank_id"
  add_foreign_key "users", "user_statuses"
end
