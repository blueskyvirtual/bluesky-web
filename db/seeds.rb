# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Airline::Flight::Type.create([
  { name: 'Charter' },
  { name: 'Event' },
  { name: 'Scheduled' }
])

Network.create([
  { name: 'IVAO', url: 'https://www.ivao.aero/', status_url: '' },
  { name: 'PilotEdge', url: 'https://www.pilotedge.net/', status_url: 'http://peaware.pilotedge.net/pilot.cfm?cid=' },
  { name: 'VATSIM', url: 'https://www.vatsim.net/', status_url: 'https://stats.vatsim.net/search_id.php?id=' }
])

Rank.create([
  { name: 'First Officer',  automatic: true, flight_count: 0  },
  { name: 'Captain',        automatic: true, flight_count: 20 },
  { name: 'Senior Captain', automatic: true, flight_count: 100 },
  { name: 'Command Captain' }
])

User::Status.create([
  { name: 'Active',   allow_login: true },
  { name: 'Inactive', allow_login: false },
  { name: 'Retired',  allow_login: false },
])
