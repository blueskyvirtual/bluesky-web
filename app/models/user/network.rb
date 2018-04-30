# frozen_string_literal: true

class User::Network < ApplicationRecord
  # Audit
  audited

  # ActiveRecord associations
  belongs_to :user
  belongs_to :network, class_name: '::Network', inverse_of: :user_networks

  # ActiveRecord validations
  validates :username, presence: true, allow_blank: false
  validates :user, uniqueness: { scope: :network }

  # Callbacks
  around_save :catch_uniqueness_exception

  private

  # This around save is a workaround for the nested attributes accepted
  # through the User model. It was allowing users to created multiple entries
  # for the same network
  #
  def catch_uniqueness_exception
    yield
  rescue ActiveRecord::RecordNotUnique
    errors.add(:user, :taken)
  end
end
