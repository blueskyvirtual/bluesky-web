# frozen_string_literal: true

class Airlines::FlightsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show map not_found]
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def create
    authorize Airline::Flight, :create?
    @flight = Airline::Flight.new

    if @flight.update_attributes(permitted_attributes(@flight))
      flash[:success] = 'Flight created successfully'
      redirect_to airline_flight_path(@flight.airline, @flight)
    else
      flash[:notice] = 'Unable to create the flight'
      render :new
    end
  end

  def destroy
    @flight = policy_scope(Airline::Flight).find(params[:id])
    authorize @flight, :destroy?

    if @flight.destroy
      flash[:success] = 'Flight deleted'
      redirect_to airline_path(@flight.airline)
    else
      flash[:notice] = 'Flight could not be deleted'
      render :edit
    end
  end

  def edit
    @flight = policy_scope(Airline::Flight).find(params[:id])
    authorize @flight, :edit?
  end

  def new
    authorize Airline::Flight, :new?
    @airline = Airline.friendly.find(params[:airline_id])
    @flight  = Airline::Flight.new(airline: @airline)
  end

  def not_found
    render :not_found, status: 404
  end

  def map
    @flight = policy_scope(Airline::Flight).find(params[:flight_id])
    authorize @flight, :show?

    respond_to do |format|
      format.js { render partial: 'map' }
    end
  end

  def show
    @flight = policy_scope(Airline::Flight).find(params[:id])
    authorize @flight, :show?

    @history = policy_scope(User::Flight)
               .where(airline_flight: @flight).page params[:page]
  end

  def update
    @flight = policy_scope(Airline::Flight).find(params[:id])
    authorize @flight, :update?

    if @flight.update_attributes(permitted_attributes(@flight))
      flash[:success] = 'Flight updated successfully'
      redirect_to airline_flight_path(@flight.airline, @flight)
    else
      flash[:notice] = 'Unable to update the flight'
      render :edit
    end
  end

  def upload
    authorize Airline::Flight, :new?
  end
end
