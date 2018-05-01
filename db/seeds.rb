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
  { name: 'Historic' },
  { name: 'Scheduled' }
])

Network.create([
  { name: 'IVAO', url: 'https://www.ivao.aero/', stats_url: '' },
  { name: 'PilotEdge', url: 'https://www.pilotedge.net/', stats_url: 'http://peaware.pilotedge.net/pilot.cfm?cid=' },
  { name: 'VATSIM', url: 'https://www.vatsim.net/', stats_url: 'https://stats.vatsim.net/search_id.php?id=' }
])

User::Rank.create([
  { name: 'First Officer',   automatic: true, flight_count: 0,    order: 1 },
  { name: 'Captain',         automatic: true, flight_count: 10,   order: 2 },
  { name: 'Senior Captain',  automatic: true, flight_count: 100,  order: 3 },
  { name: 'Command Captain', automatic: true, flight_count: 1000, order: 4 },
  { name: 'Chief Pilot',     order: 5 }
])

User::Status.create([
  { name: 'Active',   allow_login: true,  show_on_roster: true  },
  { name: 'Inactive', allow_login: false, show_on_roster: false },
  { name: 'On Leave', allow_login: true,  show_on_roster: true  },
  { name: 'Retired',  allow_login: false, show_on_roster: true  }
])
