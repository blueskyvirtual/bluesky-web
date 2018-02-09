# frozen_string_literal: true

class RosterController < ApplicationController
  helper_method :sortable_columns, :sort_column
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def index
    authorize :user, :index?
    @users = policy_scope(User).order(sort_column).page params[:page]
  end

  def show
    @user = policy_scope(User).friendly.find(params[:id])
    authorize @user, :show?
  end

  private

  def not_found
    render :not_found
  end

  def sortable_columns
    {
      pilot_id:   'Pilot ID',
      first_name: 'First Name',
      last_name:  'Last Name'
    }
  end

  def sort_column
    column = params[:sort].nil? ? nil : params[:sort].to_sym
    sortable_columns.keys.include?(column) ? params[:sort] : 'pilot_id'
  end
end
