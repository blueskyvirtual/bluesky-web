# frozen_string_literal: true

class ScheduleController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index search]

  def index
    authorize Airline::Flight, :index?
    @q = policy_scope(Airline::Flight).ransack(params[:q])

    # Default options
    @q.flight_type_name_eq = 'Scheduled' unless params[:q]
    @q.sorts = 'dep_time asc' if @q.sorts.empty?

    @flights = @q.result.page params[:page]
    @result_count = @q.result.count
  end

  def search
    index
    render :index
  end
end
