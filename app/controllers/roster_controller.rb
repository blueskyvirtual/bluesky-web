# frozen_string_literal: true

class RosterController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]

  helper_method :sortable_columns, :sort_column
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def index
    authorize :user, :index?
    @users = policy_scope(User).order(sort_column).page params[:page]
  end

  def edit
    @user = User.friendly.find(params[:id])
    authorize @user, :edit?
  end

  def destroy
    @user = User.friendly.find(params[:id])
    authorize @user, :destroy?

    if @user.destroy
      flash[:notice] = "#{@user} was successfully deleted"
      redirect_to users_path
    else
      flash[:alert] = "Unable to remove #{@user}"
      render :edit
    end
  end

  def send_password_reset
    @user = policy_scope(User).friendly.find(params[:user_id])
    authorize @user, :update?

    if @user.send_reset_password_instructions
      flash[:success] = "#{@user} has been sent password reset instructions"
    else
      flash[:notice] = "Unable to send #{@user} password reset instructions"
    end

    redirect_to edit_user_path(@user)
  end

  def show
    @user = policy_scope(User).friendly.find(params[:id])
    authorize @user, :show?
  end

  def update
    @user = policy_scope(User).friendly.find(params[:id])
    authorize @user, :update?

    if @user.update_attributes(permitted_attributes(@user))
      flash[:success] = "#{@user} updated successfully"
      redirect_to user_path(@user)
    else
      flash[:notice] = "Unable to update #{@user}"
      render :edit
    end
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
