# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      # if user admin?
      scope.all
      # else
      # scope.where("confirmed_at IS NOT NULL")
      # scope.joins(:user_status) \
      #      .where('user_statuses.show_on_roster': true) \
      #      .where('confirmed_at IS NOT NULL')
      # end
    end
  end

  def index?
    true
  end

  def destroy?
    true
  end

  def edit?
    true
  end

  def show?
    true
  end

  def update?
    edit?
  end

  def permitted_attributes
    [:pilot_id, :first_name, :last_name, :rank_id, :email, :user_status_id,
     :home_airport_id, :region_id,
     user_networks_attributes: %i[id network_id username _destroy]]
  end
end
