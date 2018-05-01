# frozen_string_literal: true

class AirlinesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show route_map]
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def index
    authorize :airline, :index?
    @q = policy_scope(Airline).ransack(params[:q])
    @q.sorts = 'name asc' if @q.sorts.empty?
    @airlines = @q.result.page params[:page]
  end

  def create
    authorize :airline, :create?
    @airline = Airline.new

    if @airline.update_attributes(permitted_attributes(@airline))
      flash[:success] = "#{@airline.name} created successfully"
      redirect_to airline_path(@airline)
    else
      flash[:notice] = "Unable to create #{@airline.name}"
      render :new
    end
  end

  def destroy
    @airline = policy_scope(Airline).friendly.find(params[:id])
    authorize @airline, :destroy?

    if @airline.destroy
      flash[:notice] = "#{@airline.name} was successfully deleted"
      redirect_to airlines_path
    else
      flash[:alert] = "Unable to remove #{@airline.name}"
      render :edit
    end
  end

  def edit
    @airline = policy_scope(Airline).friendly.find(params[:id])
    authorize @airline, :edit?
  end

  def new
    authorize :airline, :new?
    @airline = Airline.new
  end

  def not_found
    render :not_found
  end

  def route_map
    authorize :airline, :show?
    query    = 'DISTINCT ON (origin_id, destination_id) *'
    @airline = Airline.friendly.find(params[:airline_id])
    @flights = @airline.flights.select(query)

    respond_to do |format|
      format.js { render partial: 'route_map' }
    end
  end

  def show
    @airline = policy_scope(Airline).friendly.find(params[:id])
    authorize @airline, :show?
  end

  def update
    @airline = policy_scope(Airline).friendly.find(params[:id])
    authorize @airline, :update?

    if @airline.update_attributes(permitted_attributes(@airline))
      flash[:success] = "#{@airline.name} updated successfully"
      redirect_to airline_path(@airline)
    else
      flash[:notice] = "Unable to update #{@airline.name}"
      render :edit
    end
  end
end
