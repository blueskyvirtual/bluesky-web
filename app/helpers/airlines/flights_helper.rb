# frozen_string_literal: true

module Airlines::FlightsHelper
  def airport_code(airport_obj)
    airport_obj.iata || airport_obj.ident
  end

  def flight_duration(flight)
    dep_time = flight.dep_time
    arv_time = flight.arv_time

    arv_time += 1.day if dep_time > arv_time

    distance_of_time_in_words(dep_time, arv_time)
  end

  def flight_history_duration(user_flight)
    return 'En-route' if user_flight.time_in.blank?
    h = distance_of_time_in_words_hash(
      user_flight.time_out, user_flight.time_in
    )

    "#{h[:hours]}h #{h[:minutes]}m"
  end
end
