# frozen_string_literal: true

class Api::V2::AirportsController < Api::V2::BaseController
  protect_from_forgery except: %i[show]

  def show
    @airport = policy_scope(Airport).friendly.find(params[:id])
    authorize @airport, :show?

    data = @airport.as_json(include: :region)

    respond_to do |format|
      format.json { render json: data }
      format.xml  { render xml:  data }
    end
  end
end
