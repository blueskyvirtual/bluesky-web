# frozen_string_literal: true

class Api::V2::CountriesController < Api::V2::BaseController
  protect_from_forgery except: %i[index show]

  def index
    authorize :country, :index?
    @countries = policy_scope(Country).all

    respond_to do |format|
      format.json { render json: @countries.as_json }
      format.xml  { render xml:  @countries.as_json }
    end
  end

  def show
    @country = policy_scope(Country).friendly.find(params[:id])
    authorize @country, :show?

    respond_to do |format|
      format.json { render json: @country.as_json }
      format.xml  { render xml:  @country.as_json }
    end
  end
end
