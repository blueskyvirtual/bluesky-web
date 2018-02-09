# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      # if user admin?
      #   scope.all
      # else
      # scope.where("confirmed_at IS NOT NULL")
      scope.joins(:user_status) \
           .where('user_statuses.allow_login': true) \
           .where('confirmed_at IS NOT NULL')
      # end
    end
  end

  def index?
    true
  end

  def show?
    true
  end
end
