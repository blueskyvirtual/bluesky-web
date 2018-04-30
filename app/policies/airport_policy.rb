# frozen_string_literal: true

class AirportPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
      # if user admin?
      #   scope.all
      # else
      # scope.where("confirmed_at IS NOT NULL")
      # scope.joins(:user_status) \
      #      .where('user_statuses.show_on_roster': true) \
      #      .where('confirmed_at IS NOT NULL')
      # end
    end
  end

  def show?
    true
  end
end
