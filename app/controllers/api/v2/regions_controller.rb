# frozen_string_literal: true

class Api::V2::RegionsController < Api::V2::BaseController
  protect_from_forgery except: %i[index show]

  def index
    authorize :region, :index?

    @country = policy_scope(Country).friendly.find(params[:country_id])
    @regions = policy_scope(Region).where(country: @country)

    @regions = @regions.as_json(only: %i[id code local_code name])

    respond_to do |format|
      format.json { render json: @regions }
      format.xml  { render xml:  @regions }
    end
  end

  def show
    country = policy_scope(Country).friendly.find(params[:country_id])
    @region = country.regions.friendly.find(params[:id])
    authorize @region, :show?

    @region = @region.as_json(only: %i[id code local_code name])

    respond_to do |format|
      format.json { render json: @region }
      format.xml  { render xml:  @region }
    end
  end
end
