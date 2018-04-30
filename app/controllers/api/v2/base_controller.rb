# frozen_string_literal: true

class Api::V2::BaseController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def render_404
    error = { error: 'Not Found' }

    respond_to do |format|
      format.json { render json: error, status: 404 }
      format.xml  { render xml:  error, status: 404 }
    end
  end
end
