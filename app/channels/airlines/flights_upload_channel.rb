# frozen_string_literal: true

class Airlines::FlightsUploadChannel < ApplicationCable::Channel
  def send_file(data)
    chan = "airlines_flights_upload_channel-#{current_user.id}"
    msg  = "File #{data['filename']} uploaded, queueing job."

    ActionCable.server.broadcast chan,
                                 message: msg,
                                 progress: 1

    AirlineFlightsUploadJob.perform_now(data['file_uri'], chan)
  end

  def subscribed
    # stream_from "some_channel"
    stream_from "airlines_flights_upload_channel-#{current_user.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
