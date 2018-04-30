# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    skip_authorization
    @awards_count = 0
    @flight_count = Airline::Flight.count
  end
end
